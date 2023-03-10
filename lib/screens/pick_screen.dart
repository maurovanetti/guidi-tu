import 'dart:math';

import 'package:flutter/material.dart';

import '/common/common.dart';
import 'turn_instructions_screen.dart';

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
    Future.delayed(Duration.zero, () async {
      await resetTurn();
      ScoreAware.resetScores();
      _playerCount = players.length;
      var suggestedCards = [];
      var otherCards = [];
      for (var gameFeatures in allGameFeatures) {
        var gameCard = GameCard(
          name: gameFeatures.name,
          gameStart: TurnInstructionsScreen(gameFeatures: gameFeatures),
          description: gameFeatures.description,
          icon: gameFeatures.icon,
          onTap: select,
          suggested: _isSuggested(gameFeatures),
        );
        (gameCard.suggested ? suggestedCards : otherCards).add(gameCard);
      }
      suggestedCards.shuffle(Random(DateTime.now().second));
      _gameCards = [...suggestedCards, ...otherCards];
      select(_gameCards.first);
    });
  }

  void select(GameCard game) {
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

  void _startGame() {
    assert(nextTurn());
    if (mounted) {
      Navigation.replaceAll(context, () => _selectedGame.gameStart).go();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estrazione del minigioco'),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: _gameCards.toList(), // to rebuild it every time
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        key: WidgetKeys.toTurnInstructions,
        tooltip: 'Inizio',
        icon: Icons.play_arrow_rounded,
        onPressed: _startGame,
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;
  final bool suggested;
  final bool selected;
  final void Function(GameCard) onTap;
  final Widget gameStart;

  const GameCard({
    super.key,
    required this.name,
    required this.gameStart,
    required this.description,
    required this.icon,
    required this.onTap,
    this.suggested = false,
    this.selected = false,
  });

  GameCard copyWith({required bool selected}) {
    return GameCard(
      name: name,
      gameStart: gameStart,
      description: description,
      icon: icon,
      onTap: onTap,
      suggested: suggested,
      selected: selected,
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var buttonColorScheme = theme.buttonTheme.colorScheme;
    var foreground = selected ? buttonColorScheme?.onPrimaryContainer : null;
    var background = selected ? buttonColorScheme?.primaryContainer : null;
    Widget card = Card(
      key: WidgetKeys.pickGame(name),
      color: background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(icon, size: 50),
            title: Text(
              name,
              style: textTheme.headlineMedium?.copyWith(color: foreground),
            ),
            subtitle: Text(
              description,
              style: textTheme.bodyLarge?.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
    if (suggested) {
      card = ClipRect(
        child: Banner(
          message: "Suggerito",
          location: BannerLocation.topEnd,
          child: card,
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        onTap(this);
      },
      child: card,
    );
  }
}
