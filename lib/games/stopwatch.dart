import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '/common/common.dart';
import '/screens/outcome_screen.dart';
import '/screens/turn_play_screen.dart';
import 'game_area.dart';

class Stopwatch extends TurnPlayScreen {
  @override
  bool get isReadyAtStart => false;

  static const period = 6; // seconds

  static int microsecondsIntoPeriod(Duration total) =>
      total.inMicroseconds % (Stopwatch.period * 1000000);

  static double fractionOfPeriod(Duration total) =>
      microsecondsIntoPeriod(total) / (Stopwatch.period * 1000000);

  Stopwatch() : super(key: WidgetKeys.stopwatch, gameFeatures: stopwatch);

  @override
  createState() => StopwatchState();
}

class StopwatchState extends TurnPlayState<StopwatchMove> {
  @override
  Duration get elapsed =>
      Duration(microseconds: Stopwatch.microsecondsIntoPeriod(super.elapsed));

  @override
  bool get displayClock => false;
}

class StopwatchGameArea extends GameArea<StopwatchMove> {
  StopwatchGameArea({
    super.key,
    required super.setReady,
    required MoveReceiver moveReceiver,
    required super.startTime,
  }) : super(
          gameFeatures: stopwatch,
          moveReceiver: moveReceiver as MoveReceiver<StopwatchMove>,
        );

  @override
  createState() => StopwatchGameAreaState();
}

class StopwatchGameAreaState extends GameAreaState<StopwatchMove>
    with TickerProviderStateMixin {
  late final Ticker _ticker;
  double? _handPosition;
  double? _secondsIntoPeriod;

  @override
  void initState() {
    _ticker = createTicker((_) {
      var sinceStart = DateTime.now().difference(widget.startTime);
      var fractionOfPeriod = Stopwatch.fractionOfPeriod(sinceStart);
      setState(() {
        _handPosition = fractionOfPeriod * 2 * pi;
        _secondsIntoPeriod = fractionOfPeriod * Stopwatch.period;
      });
    });
    unawaited(_ticker.start());
    super.initState();
  }

  void _stop() {
    _ticker.stop();
    widget.setReady(true);
  }

  @override
  dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  StopwatchMove getMove() => StopwatchMove(
        microseconds: (_secondsIntoPeriod! * 1000000).toInt(),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(text: "STOP", onPressed: _ticker.isTicking ? _stop : null),
        Flexible(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/stopwatch/quadrant.png',
              ),
              _handPosition == null
                  ? const SizedBox.shrink()
                  : Transform.rotate(
                      angle: _handPosition!,
                      child: Image.asset(
                        'assets/images/stopwatch/hand.png',
                      ),
                    ),
              if (_secondsIntoPeriod != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: StyleGuide.regularPadding,
                    child: Text(
                      I18n.secondsFormat.format(_secondsIntoPeriod!),
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontFeatures: [const FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class StopwatchOutcome extends OutcomeScreen {
  StopwatchOutcome({super.key}) : super(gameFeatures: stopwatch);

  @override
  OutcomeScreenState<StopwatchMove> createState() => StopwatchOutcomeState();
}

class StopwatchOutcomeState extends OutcomeScreenState<StopwatchMove> {}

class StopwatchMove extends Move {
  final int microseconds;

  StopwatchMove({required this.microseconds});

  @override
  int getPointsFor(Player player, Iterable<RecordedMove<Move>> allMoves) =>
      microseconds;
}
