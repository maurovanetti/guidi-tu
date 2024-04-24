import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import 'interstitial_screen.dart';

class PickScreen extends StatefulWidget {
  const PickScreen({super.key});

  @override
  State<PickScreen> createState() => _PickScreenState();
}

class _PickScreenState extends TrackedState<PickScreen>
    with Gendered, TeamAware, TurnAware, ScoreAware {
  int? _selectedGameIndex;
  late final int _playerCount;
  List<GameCard> _gameCards = [];

  // ignore: avoid-returning-widgets
  GameCard get _selectedGame => _gameCards[_selectedGameIndex ?? 0];

  set _selectedGame(GameCard value) {
    _gameCards[_selectedGameIndex ?? 0] = value;
  }

  @override
  initState() {
    super.initState();
    Delay.atNextFrame(() {
      ScoreAware.resetScores();
      _playerCount = players.length;
      var suggestedCards = [];
      var otherCards = [];
      var availableGames = allGameFeatures.where((game) =>
          game.minPlayers <= _playerCount && game.maxPlayers >= _playerCount);
      if (kIsWeb) {
        availableGames = availableGames.where((game) => !game.mobileOnly);
      }
      for (var gameFeatures in availableGames) {
        var gameCard = GameCard(
          name: gameFeatures.name,
          gameStart: InterstitialScreen(gameFeatures: gameFeatures),
          description: gameFeatures.description,
          icon: gameFeatures.icon,
          onTap: _select,
          onIconTap: _startGame,
          suggested: _isSuggested(gameFeatures),
          rounds: gameFeatures.rounds,
        );
        (gameCard.suggested ? suggestedCards : otherCards).add(gameCard);
      }
      suggestedCards.shuffle(Random(DateTime.now().second));
      _gameCards = [...suggestedCards, ...otherCards];
      _select(_gameCards.first);
    });
  }

  void _select(GameCard game) {
    debugPrint("Selecting ${game.name}");
    setState(() {
      if (_selectedGameIndex != null) {
        _selectedGame = _selectedGame.copyWith(selected: false);
      }
      _selectedGameIndex =
          _gameCards.indexWhere((card) => card.name == game.name);
      _selectedGame = _selectedGame.copyWith(selected: true);
    });
  }

  bool _isSuggested(GameFeatures gameFeatures) =>
      _playerCount >= gameFeatures.minSuggestedPlayers &&
      _playerCount <= gameFeatures.maxSuggestedPlayers;

  void _startGame(GameCard game) {
    resetTurn(rounds: game.rounds);
    var _ = nextTurn();
    if (mounted) {
      Navigation.push(context, () => game.gameStart).go();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estrazione del minigioco'),
      ),
      body: Center(
        child: Scrollbar(
          thumbVisibility: true,
          child: ListView(
            primary: true,
            shrinkWrap: true,
            children: [
              ..._gameCards, // to rebuild it every time
              const SafeMarginForCustomFloatingActionButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.name,
    required this.gameStart,
    required this.description,
    required this.icon,
    required this.onTap,
    required this.onIconTap,
    this.suggested = false,
    this.selected = false,
    this.rounds = 1,
  });

  final String name;
  final String description;
  final IconData icon;
  final bool suggested;
  final bool selected;
  final FutureOr<void> Function(GameCard card) onTap;
  final FutureOr<void> Function(GameCard card) onIconTap;
  final Widget gameStart;
  final int rounds;

  // ignore: avoid-incomplete-copy-with
  GameCard copyWith({required bool selected}) {
    return GameCard(
      name: name,
      gameStart: gameStart,
      description: description,
      icon: icon,
      onTap: onTap,
      onIconTap: onIconTap,
      suggested: suggested,
      selected: selected,
      rounds: rounds,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final buttonColorScheme = theme.buttonTheme.colorScheme;
    final foreground = selected ? buttonColorScheme?.onPrimaryContainer : null;
    final background = selected ? buttonColorScheme?.primaryContainer : null;
    final bright = selected ? buttonColorScheme?.primary : null;
    final dark = selected ? buttonColorScheme?.onPrimary : null;
    final halfWay = Color.lerp(bright, dark, 0.5);

    Widget card = Card(
      key: WidgetKeys.pickGame(name),
      color: background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(
              icon,
              size: 50,
              color: selected ? buttonColorScheme?.primary : null,
            ),
            title: FittedText(
              name,
              style: textTheme.headlineMedium?.copyWith(color: foreground),
              alignment: Alignment.centerLeft,
            ),
            subtitle: FittedText(
              description,
              style: textTheme.bodyLarge?.copyWith(color: foreground),
              alignment: Alignment.centerLeft,
            ),
            trailing: selected
                ? IconButton(
                    key: WidgetKeys.toInterstitial(name),
                    icon: Icon(
                      Icons.play_arrow_rounded,
                      size: 32,
                      color: dark,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: bright,
                      highlightColor: halfWay,
                    ),
                    onPressed: () {
                      var _ = onIconTap(this);
                    },
                  )
                : const IconButton(
                    icon: Icon(
                      Icons.play_arrow_rounded,
                      size: 32,
                      color: Colors.transparent,
                    ),
                    onPressed: null,
                  ),
          ),
        ],
      ),
    );
    if (suggested) {
      card = ClipRect(
        child: Banner(
          message: "Suggerito",
          location: BannerLocation.topStart,
          child: card,
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        var _ = onTap(this);
      },
      child: card,
    );
  }
}
