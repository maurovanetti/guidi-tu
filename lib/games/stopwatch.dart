import 'package:flutter/material.dart';

import '/common/common.dart';
import '/screens/outcome_screen.dart';
import '/screens/turn_play_screen.dart';
import 'game_area.dart';

class Stopwatch extends TurnPlayScreen {
  static const period = 3; // seconds

  Stopwatch() : super(key: WidgetKeys.stopwatch, gameFeatures: stopwatch);

  @override
  createState() => StopwatchState();
}

class StopwatchState extends TurnPlayState<NoMove> {
  @override
  Duration get elapsed => Duration(
        microseconds:
            // ignore: no-magic-number
            super.elapsed.inMicroseconds % (Stopwatch.period * 1000000),
      );

  @override
  bool get displayClock => false;
}

class StopwatchGameArea extends GameArea<NoMove> {
  StopwatchGameArea({
    super.key,
    required super.setReady,
    required MoveReceiver moveReceiver,
    required super.startTime,
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
    return Text("Start time: ${widget.startTime}");
  }
}

class StopwatchOutcome extends OutcomeScreen {
  StopwatchOutcome({super.key}) : super(gameFeatures: stopwatch);

  @override
  OutcomeScreenState<NoMove> createState() => StopwatchOutcomeState();
}

class StopwatchOutcomeState extends OutcomeScreenState<NoMove> {}
