import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/screens/turn_play_screen.dart';
import '../screens/outcome_screen.dart';
import 'boules/boules_module.dart';
import 'boules/final_boules_outcome.dart';
import 'game_area.dart';

class Boules extends TurnPlayScreen {
  @override
  bool get isReadyAtStart => false;

  Boules() : super(key: WidgetKeys.boules, gameFeatures: boules);

  @override
  createState() => BoulesState();
}

class BoulesState extends TurnPlayState<BoulesMove> {
  /// All moves must be re-recorded because every move can modify the positions
  /// of other bowls (and the jack).
  @override
  recordCurrentMove(Duration duration) {
    recordMove(
      receiveMove(),
      duration.inMicroseconds / Duration.microsecondsPerSecond,
    );
  }
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
    super.initState();
    _gameModule = BoulesModule(
      setReady: ({bool ready = true}) {
        QuickMessage().hideQuickMessage();
        widget.setReady(ready: ready);
      },
      displayMessage: displayMessage,
    );
  }

  @override
  MoveUpdate<BoulesMove> getMoveUpdate() => (
        newMove: BoulesMove(
          bowlPosition: _gameModule.lastBowlPosition,
          jackPosition: _gameModule.updatedJackPosition,
        ),
        updatedOldMoves: {},
      );

  void displayMessage(String message) =>
      QuickMessage().showQuickMessage(message, context: context, longer: true);

  @override
  Widget build(BuildContext context) => GameWidget(game: _gameModule);
}

class BoulesOutcome extends OutcomeScreen {
  BoulesOutcome({super.key}) : super(gameFeatures: boules);

  @override
  BoulesOutcomeState createState() => BoulesOutcomeState();
}

class BoulesOutcomeState extends OutcomeScreenState<BoulesMove> {
  @override
  void initOutcome() {
    repeatable = true;
    outcomeWidget = const FinalBoulesOutcome();
  }
}

class BoulesMove extends Move {
  final Vector2 bowlPosition;
  // ignore: avoid-global-state
  static Vector2 finalJackPosition = Vector2.zero();

  BoulesMove({required this.bowlPosition, required Vector2 jackPosition}) {
    debugPrint("Updating jack position to $jackPosition");
    BoulesMove.finalJackPosition = jackPosition;
  }

  double distanceFromJack() {
    return bowlPosition.distanceTo(finalJackPosition);
  }

  @override
  int getPointsFor(Player player, Iterable<RecordedMove<Move>> allMoves) {
    return (distanceFromJack() * 100).toInt();
  }

  @override
  int getTurnPriorityFor(
    Player player,
    Iterable<RecordedMove<Move>> allMoves,
  ) =>
      -super.getTurnPriorityFor(player, allMoves);

  @override
  int samePlayerCompareTo(Move other) {
    return distanceFromJack()
        .compareTo((other as BoulesMove).distanceFromJack());
  }
}
