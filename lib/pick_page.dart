import 'package:flutter/material.dart';

import 'common/config.dart';
import 'common/custom_fab.dart';
import 'common/navigation.dart';
import 'common/team_aware.dart';
import 'common/turn_aware.dart';
import 'games/large_shot_game_start.dart';
import 'games/morra_game_start.dart';
import 'games/small_shot_game_start.dart';

class PickPage extends StatefulWidget {
  const PickPage({super.key});

  @override
  State<PickPage> createState() => _PickPageState();
}

class _PickPageState extends State<PickPage> with TeamAware, TurnAware {
  int? _selectedGameIndex;
  late final int _playerCount;
  List<GameCard> _gameCards = [];

  GameCard get _selectedGame => _gameCards[_selectedGameIndex ?? 0];
  set _selectedGame(GameCard value) {
    _gameCards[_selectedGameIndex ?? 0] = value;
  }

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await resetTurn();
      _playerCount = players.length;
      var gameCards = [
        GameCard(
          name: "Spararla grossa",
          gameStart: const LargeShotGameStart(),
          description: "Guida chi sceglie il numero più basso.\n"
              "Paga chi sceglie il numero più alto.",
          icon: Icons.arrow_circle_up_rounded,
          onTap: select,
          suggested: _suggestedFor(2, maxPlayers),
        ),
        GameCard(
          name: "Cadere in basso",
          gameStart: const SmallShotGameStart(),
          description: "Guida chi sceglie il numero più alto.\n"
              "Paga chi sceglie il numero più basso.",
          icon: Icons.arrow_circle_down_rounded,
          onTap: select,
          suggested: _suggestedFor(2, maxPlayers),
        ),
        GameCard(
          name: "Morra",
          gameStart: const MorraGameStart(),
          description: "Guida chi si avvicina di meno alla somma.\n"
              "Paga chi si avvicina di più.",
          icon: Icons.back_hand_rounded,
          onTap: select,
          suggested: _suggestedFor(2, maxPlayers),
        ),
      ];
      var suggestedCards = gameCards.where((card) => card.suggested).toList();
      suggestedCards.shuffle();
      var otherCards = _gameCards.where((card) => !card.suggested);
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

  bool _suggestedFor(int min, int max) {
    return _playerCount >= min && _playerCount <= max;
  }

  Widget _startGame() {
    return _selectedGame.gameStart;
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
        onPressed: Navigation.replaceLast(context, _startGame).go,
        tooltip: 'Inizio',
        icon: Icons.play_arrow_rounded,
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
    var foreground = selected
        ? Theme.of(context).buttonTheme.colorScheme?.onPrimaryContainer
        : null;
    var background = selected
        ? Theme.of(context).buttonTheme.colorScheme?.primaryContainer
        : null;
    Widget card = Card(
      color: background,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(icon, size: 50),
            title: Text(
              name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: foreground,
                  ),
            ),
            subtitle: Text(description,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: foreground)),
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
