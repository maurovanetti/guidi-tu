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

  Stopwatch() : super(key: WidgetKeys.stopwatch, gameFeatures: stopwatch);

  static const period = 6; // seconds

  static int microsecondsIntoPeriod(Duration total) =>
      total.inMicroseconds %
      (Stopwatch.period * Duration.microsecondsPerSecond);

  static double fractionOfPeriod(Duration total) =>
      microsecondsIntoPeriod(total) /
      (Stopwatch.period * Duration.microsecondsPerSecond);

  @override
  createState() => StopwatchState();
}

class StopwatchState extends TurnPlayState<StopwatchMove> {
  @override
  Duration get elapsed =>
      Duration(microseconds: Stopwatch.microsecondsIntoPeriod(super.elapsed));
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
  static const badColor = Colors.redAccent;
  static const averageColor = Colors.orangeAccent;
  static const goodColor = Colors.greenAccent;

  late final Ticker _ticker;
  double? _handPosition;
  double? _secondsIntoPeriod;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) {
      var sinceStart = DateTime.now().difference(widget.startTime);
      var fractionOfPeriod = Stopwatch.fractionOfPeriod(sinceStart);
      setState(() {
        _handPosition = fractionOfPeriod * 2 * pi;
        _secondsIntoPeriod = fractionOfPeriod * Stopwatch.period;
      });
    });
    unawaited(_ticker.start());
  }

  void _stop() {
    _ticker.stop();
    widget.setReady(ready: true);
  }

  _trafficLightColor(double t) {
    var t1 = Stopwatch.period / 2;
    var t2 = Stopwatch.period * (3 / 4);
    var t3 = Stopwatch.period;
    if (t < t1) {
      return badColor;
    } else if (t < t2) {
      return Color.lerp(badColor, averageColor, (t - t1) / (t2 - t1));
      // (False positive)
      // ignore: avoid-redundant-else
    } else {
      return Color.lerp(averageColor, goodColor, (t - t2) / (t3 - t2));
    }
  }

  @override
  dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  StopwatchMove getMove() => StopwatchMove(
        microseconds:
            (_secondsIntoPeriod! * Duration.microsecondsPerSecond).toInt(),
      );

  @override
  Widget build(BuildContext context) {
    var leftOffsetForLabel = MediaQuery.of(context).size.width / 2 - 35;
    var bottomOffsetForLabel = 20 + (_secondsIntoPeriod ?? 0) * 5;
    return Column(
      children: [
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
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: leftOffsetForLabel,
                      bottom: bottomOffsetForLabel,
                    ),
                    child: Text(
                      I18n.secondsFormat.format(_secondsIntoPeriod!),
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: _trafficLightColor(_secondsIntoPeriod!),
                        fontWeight: FontWeight.bold,
                        fontFeatures: [const FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        CustomButton(text: "STOP", onPressed: _ticker.isTicking ? _stop : null),
      ],
    );
  }
}

// TODO Take a chance to give some advice
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
