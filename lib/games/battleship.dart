import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/game_features.dart';
import '/games/turn_play.dart';
import '../common/turn_aware.dart';
import 'flame/battleship_module.dart';
import 'outcome_screen.dart';

class Battleship extends TurnPlay {
  Battleship({super.key}) : super(gameFeatures: battleship);

  @override
  createState() => BattleshipState();
}

class BattleshipState extends TurnPlayState<BattleshipMove> {
  @override
  BattleshipMove get lastMove => BattleshipMove(time: elapsedSeconds);

  @override
  buildGameArea() => GameWidget(game: BattleshipModule());
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
  BattleshipMove({required super.time});

  @override
  int getPointsWith(Iterable<Move> allMoves) {
    return 0; // TODO
  }
}
