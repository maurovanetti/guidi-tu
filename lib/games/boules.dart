// ignore_for_file: avoid-non-ascii-symbols

import 'package:collection/collection.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/screens/turn_play_screen.dart';
import '../screens/outcome_screen.dart';
import 'boules/boules_module.dart';
import 'game_area.dart';

class Boules extends TurnPlayScreen {
  @override
  bool get isReadyAtStart => false;

  Boules() : super(key: WidgetKeys.boules, gameFeatures: boules);

  @override
  createState() => TurnPlayState<BoulesMove>();
}

class BoulesGameArea extends GameArea<BoulesMove> {
  BoulesGameArea({
    super.key,
    required super.setReady,
    required MoveReceiver moveReceiver,
    required super.startTime,
  }) : super(
          gameFeatures: boules,
          moveReceiver: moveReceiver as MoveReceiver<BoulesMove>,
        );

  @override
  createState() => BoulesGameAreaState();
}

class BoulesGameAreaState extends GameAreaState<BoulesMove>
    with TickerProviderStateMixin {
  late final BoulesModule _gameModule;

  @override
  void initState() {
    _gameModule = BoulesModule(setReady: widget.setReady);
    super.initState();
  }

  @override
  BoulesMove getMove() =>
      BoulesMove(bowlPosition: _gameModule.lastBowlPosition!);

  @override
  Widget build(BuildContext context) => GameWidget(game: _gameModule);
}

class BoulesOutcome extends OutcomeScreen {
  BoulesOutcome({super.key}) : super(gameFeatures: ouija);

  @override
  BoulesOutcomeState createState() => BoulesOutcomeState();
}

class BoulesOutcomeState extends OutcomeScreenState<BoulesMove> {}

class BoulesMove extends Move {
  final Vector2 bowlPosition;

  BoulesMove({required this.bowlPosition});

  double distanceFromJack() {
    Vector2 jackPosition = Vector2.zero(); // TODO
    return bowlPosition.distanceTo(jackPosition);
  }

  @override
  int getPointsFor(Player player, Iterable<RecordedMove<Move>> allMoves) {
    var sortedMoves = allMoves.sortedByCompare(
      (rm) => (rm.move as BoulesMove).distanceFromJack(),
      (a, b) => a.compareTo(b),
    );
    return sortedMoves.indexWhere((rm) => rm.player == player);
  }
}
