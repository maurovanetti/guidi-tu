// ignore_for_file: avoid-non-ascii-symbols

import 'dart:async';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '/common/common.dart';
import '/screens/stories_screen.dart';
import '/screens/turn_play_screen.dart';
import 'game_area.dart';
import 'steady_hand/steady_hand_module.dart';

class SteadyHand extends TurnPlayScreen {
  @override
  bool get isReadyAtStart => false;

  @override
  Color get backgroundColor => Colors.black;

  SteadyHand() : super(key: WidgetKeys.steadyHand, gameFeatures: steadyHand);

  @override
  createState() => TurnPlayState<SteadyHandMove>();
}

class SteadyHandGameArea extends GameArea<SteadyHandMove> {
  SteadyHandGameArea({
    super.key,
    required super.onChangeReady,
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
    super.initState();
    _gameModule = SteadyHandModule(onFallen: _handleStop);
    _ticker = createTicker((_) {
      var truncated = _updateSeconds().toInt();
      if (truncated != _displaying) {
        setState(() {
          _displaying = truncated;
        });
      }
    });
    unawaited(_ticker.start());
  }

  double _updateSeconds() {
    var sinceStart = DateTime.now().difference(widget.startTime);
    _seconds = sinceStart.inMicroseconds / Duration.microsecondsPerSecond;
    return _seconds!;
  }

  void _handleStop() {
    _ticker.stop();
    var _ = _updateSeconds();
    widget.onChangeReady(ready: true);
  }

  @override
  dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  MoveUpdate<SteadyHandMove> getMoveUpdate() => (
        newMove: SteadyHandMove(
          microseconds: (_seconds! * Duration.microsecondsPerSecond).toInt(),
        ),
        updatedOldMoves: {},
      );

  @override
  Widget build(BuildContext context) {
    var leftOffsetForLabel = MediaQuery.sizeOf(context).width / 2 - 35;
    var bottomOffsetForLabel = (_seconds ?? 0.0) / 10.0;
    return Center(
      child: Flexible(
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
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFeatures: [const FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class SteadyHandOutcome extends StoriesScreen<SteadyHandMove> {
  SteadyHandOutcome({super.key}) : super(gameFeatures: steadyHand);

  @override
  StoriesScreenState<SteadyHandMove> createState() => SteadyHandOutcomeState();
}

class SteadyHandOutcomeState extends StoriesScreenState<SteadyHandMove> {
  late final List<int> _playerTimes;

  @override
  void tellPlayerStories() {
    int bestTime = 0;
    _playerTimes = List.filled(players.length, 0);
    for (var playerIndex in TurnAware.turns) {
      var player = players[playerIndex];
      final stories = [
        $.steadyHandStory1,
        $.steadyHandStory2,
        $.steadyHandStory3,
      ];
      Declension story = stories[Random().nextInt(3)];
      playerStories[playerIndex] = player.t(story);
      var time = getRecordedMove(player).move.microseconds;
      _playerTimes[playerIndex] = time;
      bestTime = max(time, bestTime);
    }
    for (var playerIndex in TurnAware.turns) {
      var relativeOutcome = _playerTimes[playerIndex] / bestTime;
      String ending;
      if (relativeOutcome < 1 / 10) {
        ending = $.steadyHandStorySuffix1;
      } else if (relativeOutcome < 1 / 2) {
        ending = $.steadyHandStorySuffix2;
      } else if (relativeOutcome < 3 / 4) {
        ending = $.steadyHandStorySuffix3;
      } else {
        ending = $.steadyHandStorySuffix4;
      }
      playerStories[playerIndex] += ending;
    }
  }

  @override
  PlayerPerformance getPlayerPerformance(Player player) => PlayerPerformance(
        player,
        primaryText:
            steadyHand.onFormatPoints(getBestMove(player).microseconds, $),
      );
}

class SteadyHandMove extends Move {
  final int microseconds;

  const SteadyHandMove({required this.microseconds});

  @override
  int getPointsFor(Player player, Iterable<RecordedMove<Move>> allMoves) =>
      microseconds;
}
