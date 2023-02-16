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
import '/games/turn_interstitial.dart';
import '../common/widget_keys.dart';
import 'completion_screen.dart';

abstract class TurnPlay extends GameSpecificStatefulWidget {
  const TurnPlay({super.key, required super.gameFeatures});

  @override
  TurnPlayState createState();
}

abstract class TurnPlayState<T extends Move> extends GameSpecificState<TurnPlay>
    with Gendered, TeamAware, TurnAware {
  late DateTime _startTime;
  Timer? _timer;
  Duration get elapsed => DateTime.now().difference(_startTime);
  double get elapsedSeconds => elapsed.inMicroseconds * 1e-6;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _recordTurn() async {
    _timer?.cancel();
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
          children: [
            PlayerTag(TurnAware.currentPlayer),
            const Gap(),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: AspectRatio(
                  aspectRatio: 1.0, // It's a square
                  child: buildGameArea(),
                )),
            const Gap(),
            CustomButton(
              key: toNextTurnWidgetKey,
              text: "Ho finito!",
              onPressed: _completeTurn,
            ),
            Clock(elapsed),
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

class Clock extends StatelessWidget {
  final Duration duration;

  const Clock(this.duration, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Tempo trascorso: ${duration.inSeconds}"',
          style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}
