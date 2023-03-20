import 'package:flutter/material.dart';

import '/common/common.dart';
import '/screens/outcome_screen.dart';
import '/screens/turn_play_screen.dart';
import 'game_area.dart';

class Stopwatch extends TurnPlayScreen {
  Stopwatch() : super(key: WidgetKeys.stopwatch, gameFeatures: stopwatch);

  @override
  createState() => StopwatchState();
}

class StopwatchState extends TurnPlayState<NoMove> {
  @override
  Duration get elapsed =>
      // ignore: no-magic-number
      Duration(microseconds: super.elapsed.inMicroseconds % 1000000);

  @override
  bool get displayClock => false;
}

class StopwatchGameArea extends GameArea<NoMove> {
  StopwatchGameArea({
    super.key,
    required super.setReady,
    required MoveReceiver moveReceiver,
  }) : super(
          gameFeatures: stopwatch,
          moveReceiver: moveReceiver as MoveReceiver<NoMove>,
        );

  @override
  createState() => StopwatchGameAreaState();
}

class StopwatchGameAreaState extends GameAreaState<NoMove> {
  @override
  NoMove getMove() => NoMove();

  @override
  Widget build(BuildContext context) {
    return Text("Start time: ...");
  }
}

class StopwatchOutcome extends OutcomeScreen {
  StopwatchOutcome({super.key}) : super(gameFeatures: stopwatch);

  @override
  OutcomeScreenState<NoMove> createState() => StopwatchOutcomeState();
}

class StopwatchOutcomeState extends OutcomeScreenState<NoMove> {}
