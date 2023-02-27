import 'dart:async';

import 'package:flutter/material.dart';

import '/common/custom_button.dart';
import '/common/game_aware.dart';
import '/common/gap.dart';
import '/common/gender.dart';
import '/common/navigation.dart';
import '/common/player.dart';
import '/common/team_aware.dart';
import '/common/turn_aware.dart';
import '/common/widget_keys.dart';
import '/games/turn_interstitial.dart';
import '../common/style_guide.dart';
import 'completion_screen.dart';

abstract class TurnPlay extends GameSpecificStatefulWidget {
  const TurnPlay({super.key, required super.gameFeatures});

  @override
  TurnPlayState createState();
}

abstract class TurnPlayState<T extends Move> extends GameSpecificState<TurnPlay>
    with Gendered, TeamAware, TurnAware {
  late DateTime _startTime;

  Duration get elapsed => DateTime.now().difference(_startTime);

  double get elapsedSeconds => elapsed.inMicroseconds * 1e-6;

  bool get isReadyAtStart => true;

  late bool _ready;

  void setReady(bool ready) {
    if (_ready != ready) {
      setState(() {
        _ready = ready;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _ready = isReadyAtStart;
  }

  Future<void> _recordTurn() async {
    recordMove(lastMove);
  }

  T get lastMove;

  void _completeTurn() async {
    await _recordTurn();
    var hasEveryonePlayed = !await nextTurn();
    if (mounted) {
      if (hasEveryonePlayed) {
        Navigation.replaceLast(
            context,
            () => CompletionScreen(
                  gameFeatures: widget.gameFeatures,
                )).go();
      } else {
        Navigation.replaceLast(context,
            () => TurnInterstitial(gameFeatures: widget.gameFeatures)).go();
      }
    }
  }

  // Override this to build the game area
  Widget buildGameArea() => buildPlaceHolder();

  @override
  Widget build(BuildContext context) {
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
                child: buildGameArea(),
              ),
            ),
            const Gap(),
            CustomButton(
              key: toNextTurnWidgetKey,
              text: "Ho finito!",
              onPressed: _ready ? _completeTurn : null,
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
      child: Text('Tempo trascorso: ${_duration.inSeconds}"',
          style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}
