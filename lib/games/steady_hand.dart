import 'dart:async';
import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '/common/common.dart';
import '/screens/outcome_screen.dart';
import '/screens/turn_play_screen.dart';
import 'game_area.dart';
import 'steady_hand/steady_hand_module.dart';

class SteadyHand extends TurnPlayScreen {
  @override
  bool get isReadyAtStart => false;

  SteadyHand() : super(key: WidgetKeys.steadyHand, gameFeatures: steadyHand);

  @override
  createState() => TurnPlayState<SteadyHandMove>();
}

class SteadyHandGameArea extends GameArea<SteadyHandMove> {
  SteadyHandGameArea({
    super.key,
    required super.setReady,
    required MoveReceiver moveReceiver,
    required super.startTime,
  }) : super(
          gameFeatures: steadyHand,
          moveReceiver: moveReceiver as MoveReceiver<SteadyHandMove>,
        );

  @override
  createState() => SteadyHandGameAreaState();
}

class SteadyHandGameAreaState extends GameAreaState<SteadyHandMove>
    with TickerProviderStateMixin {
  late final Ticker _ticker;
  double? _seconds;
  int _displaying = 0;
  late final SteadyHandModule _gameModule;

  @override
  void initState() {
    _gameModule = SteadyHandModule(notifyFallen: _stop);
    _ticker = createTicker((_) {
      var truncated = _updateSeconds().toInt();
      if (truncated != _displaying) {
        setState(() {
          _displaying = truncated;
        });
      }
    });
    unawaited(_ticker.start());
    super.initState();
  }

  _updateSeconds() {
    var sinceStart = DateTime.now().difference(widget.startTime);
    _seconds = sinceStart.inMicroseconds / Duration.microsecondsPerSecond;
    return _seconds;
  }

  void _stop() {
    _ticker.stop();
    var _ = _updateSeconds();
    widget.setReady(true);
  }

  @override
  dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  SteadyHandMove getMove() => SteadyHandMove(
        microseconds: (_seconds! * Duration.microsecondsPerSecond).toInt(),
      );

  @override
  Widget build(BuildContext context) {
    // ignore: no-magic-number
    var leftOffsetForLabel = MediaQuery.of(context).size.width / 2 - 35;
    var bottomOffsetForLabel = (_seconds ?? 0.0) / 10.0;
    return Column(
      children: [
        Flexible(
          child: Stack(
            alignment: Alignment.center,
            children: [
              GameWidget(game: _gameModule),
              if (_seconds != null)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: leftOffsetForLabel,
                      bottom: bottomOffsetForLabel,
                    ),
                    child: Text(
                      '$_displaying"',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
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

// TODO Take a chance to give some advice
class SteadyHandOutcome extends OutcomeScreen {
  SteadyHandOutcome({super.key}) : super(gameFeatures: steadyHand);

  @override
  OutcomeScreenState<SteadyHandMove> createState() => SteadyHandOutcomeState();
}

class SteadyHandOutcomeState extends OutcomeScreenState<SteadyHandMove> {}

class SteadyHandMove extends Move {
  final int microseconds;

  SteadyHandMove({required this.microseconds});

  @override
  int getPointsFor(Player player, Iterable<RecordedMove<Move>> allMoves) =>
      microseconds;
}
