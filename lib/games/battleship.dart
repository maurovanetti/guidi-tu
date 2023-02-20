import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/game_features.dart';
import '/games/turn_play.dart';
import '../common/turn_aware.dart';
import 'flame/battleship_board.dart';
import 'flame/battleship_item.dart';
import 'flame/battleship_module.dart';
import 'outcome_screen.dart';

class Battleship extends TurnPlay {
  Battleship({super.key}) : super(gameFeatures: battleship);

  @override
  createState() => BattleshipState();
}

class BattleshipState extends TurnPlayState<BattleshipMove> {
  late BattleshipModule _gameModule;

  @override
  bool get isReadyAtStart => false;

  @override
  BattleshipMove get lastMove =>
      BattleshipMove(
          time: elapsedSeconds, placedItems: _gameModule.board.placedItems);

  @override
  buildGameArea() => GameWidget(game: _gameModule);

  @override
  void initState() {
    _gameModule = BattleshipModule(setReady: setReady);
    super.initState();
  }
}

class BattleshipOutcome extends OutcomeScreen {
  BattleshipOutcome({super.key}) : super(gameFeatures: battleship);

  @override
  BattleshipOutcomeState createState() => BattleshipOutcomeState();
}

class BattleshipOutcomeState extends OutcomeScreenState<BattleshipMove> {
  @override
  initState() {
    super.initState();
    for (var playerIndex in TurnAware.turns) {
      var player = players[playerIndex];
      // TODO
    }
  }

  @override
  Widget buildOutcome() => super.buildOutcome(); // TODO
}

class BattleshipMove extends Move {
  final Map<BattleshipItem, BattleshipBoardCell> placedItems;

  BattleshipMove({required super.time, required this.placedItems});

  @override
  int getPointsWith(Iterable<Move> allMoves) {
    return 0; // TODO
  }
}
