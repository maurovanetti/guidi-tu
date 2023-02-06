import 'dart:async';

import 'package:flutter/material.dart';

import '/common/custom_button.dart';
import '/common/game_features.dart';
import '/common/gap.dart';
import '/common/navigation.dart';
import '/common/player.dart';
import '/common/score_aware.dart';
import '/common/team_aware.dart';
import '/common/turn_aware.dart';
import '/games/turn_interstitial.dart';

abstract class TurnPlay extends StatefulWidget {
  GameFeatures get gameFeatures;

  const TurnPlay({super.key});

  @override
  TurnPlayState createState() => TurnPlayState();
}

class TurnPlayState extends State<TurnPlay>
    with TeamAware, TurnAware, ScoreAware {
  late DateTime _startTime;
  Timer? _timer;
  Duration get _elapsed => DateTime.now().difference(_startTime);

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

  Future<void> _scoreTurn() async {
    _timer?.cancel();
    debugPrint("${TurnAware.currentPlayer.name} scored $points points");
    var score = Score(
        points: points,
        time: _elapsed.inMicroseconds * 0.000001,
        lessIsMore: widget.gameFeatures.lessIsMore);
    ScoreAware.recordScore(TurnAware.currentPlayer, score);
  }

  void _completeTurn() async {
    await _scoreTurn();
    var hasEveryonePlayed = !await nextTurn();
    if (mounted) {
      if (hasEveryonePlayed) {
        Navigation.replaceLast(
            context, () => widget.gameFeatures.placementWidget).go();
      } else {
        Navigation.replaceLast(context,
            () => TurnInterstitial(gameFeatures: widget.gameFeatures)).go();
      }
    }
  }

  // Override this to customize the point calculation
  int get points => 0;

  // Override this to build the game area
  Widget buildGameArea() {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text(
          widget.gameFeatures.name,
          style: const TextStyle(fontSize: 48),
        ),
      ),
    );
  }

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
              text: "Ho finito!",
              onPressed: _completeTurn,
            ),
            Clock(_elapsed),
          ],
        ),
      ),
    );
  }
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
