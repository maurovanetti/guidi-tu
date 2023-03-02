import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '/common/custom_button.dart';
import '/common/game_aware.dart';
import '/common/game_features.dart';
import '/common/gap.dart';
import '/common/gender.dart';
import '/common/navigation.dart';
import '/common/player.dart';
import '/common/style_guide.dart';
import '/common/team_aware.dart';
import '/common/turn_aware.dart';
import '/common/widget_keys.dart';
import '/games/turn_interstitial.dart';
import 'completion_screen.dart';

abstract class TurnPlay extends GameSpecificStatefulWidget {
  const TurnPlay({super.key, required super.gameFeatures});

  @override
  TurnPlayState createState();
}

class TurnPlayState<T extends Move> extends GameSpecificState<TurnPlay>
    with Gendered, TeamAware, TurnAware {
  T lastMove(double time);

  bool ready = true; // Can be reset to false in initState() if needed.

  void setReady(bool ready) {
    if (this.ready != ready) {
      debugPrint("Ready changed to $ready");
      setState(() {
        this.ready = ready;
      });
    }
  }

  Future<void> completeTurn(Duration duration) async {
    // ignore: no-magic-number
    recordMove(lastMove(duration.inMicroseconds / 1000000));
    var hasEveryonePlayed = !await nextTurn();
    if (mounted) {
      if (hasEveryonePlayed) {
        Navigation.replaceLast(
          context,
          () => CompletionScreen(
            gameFeatures: widget.gameFeatures,
          ),
        ).go();
      } else {
        Navigation.replaceLast(
          context,
          () => TurnInterstitial(gameFeatures: widget.gameFeatures),
        ).go();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameAreaContainer(
      gameFeatures: widget.gameFeatures,
      onCompleteTurn: completeTurn,
      // ready can be passed here if the game can switch between ready and not.
    );
  }
}

class GameAreaContainer extends StatefulWidget {
  final bool ready;
  final GameFeatures gameFeatures;
  final FutureOr<void> Function(Duration) onCompleteTurn;

  const GameAreaContainer({
    super.key,
    this.ready = true,
    required this.gameFeatures,
    required this.onCompleteTurn,
  });

  @override
  createState() => GameAreaContainerState();
}

class GameAreaContainerState extends State<GameAreaContainer> {
  late DateTime _startTime;

  Duration get elapsed => DateTime.now().difference(_startTime);

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Rebuilding GameAreaContainer");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameFeatures.name),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          physics: widget.gameFeatures.usesRigidGameArea
              ? const NeverScrollableScrollPhysics()
              : null,
          children: [
            PlayerTag(TurnAware.currentPlayer),
            const Gap(),
            Padding(
              padding: StyleGuide.regularPadding,
              child: AspectRatio(
                key: gameAreaWidgetKey,
                aspectRatio: 1.0, // It's a square
                child: widget.gameFeatures.playWidget(),
              ),
            ),
            const Gap(),
            CustomButton(
              key: toNextTurnWidgetKey,
              text: "Ho finito!",
              onPressed: widget.ready
                  ? () {
                      widget.onCompleteTurn(elapsed);
                    }
                  : null,
            ),
            Clock(_startTime, key: clockWidgetKey),
          ],
        ),
      ),
    );
  }
}

class NoMove extends Move {
  NoMove({required super.time});

  @override
  int getPointsWith(Iterable<Move> allMoves) => 0;
}

class Clock extends StatefulWidget {
  final DateTime startTime;

  const Clock(this.startTime, {super.key});

  @override
  createState() => ClockState();
}

class ClockState extends State<Clock> {
  late Timer _timer;

  Duration _duration = Duration.zero;

  @override
  initState() {
    super.initState();
    _untilNextSecond();
  }

  void _untilNextSecond() {
    int targetMicro = widget.startTime.microsecondsSinceEpoch;
    int currentMicro = DateTime.now().microsecondsSinceEpoch;
    int diffMicro = (targetMicro - currentMicro) % 1000000;
    _timer = Timer(Duration(microseconds: diffMicro), () {
      setState(() {
        _duration = DateTime.now().difference(widget.startTime);
      });
      // To check the error in microseconds, uncomment this line:
      // debugPrint((_duration.inMicroseconds * 1e-6).toString());
      // It's always below 0.1 seconds in emulator tests
      _untilNextSecond();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Tempo trascorso: ${_duration.inSeconds}"',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}
