import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:guidi_tu/common/player.dart';

import '/common/game_features.dart';
import '/common/gap.dart';
import '/games/turn_play.dart';
import '../common/turn_aware.dart';
import 'outcome_screen.dart';
import 'shot.dart';

class Morra extends TurnPlay {
  Morra({super.key}) : super(gameFeatures: morra);

  @override
  createState() => MorraState();
}

class MorraState extends ShotState<MorraMove> {
  int _fingers = 0;

  @override
  initState() {
    super.initState();
    _fingers = 0;
  }

  @override
  MorraMove get lastMove =>
      MorraMove(time: elapsedSeconds, fingers: _fingers, n: n);

  void _changeFingers(int delta) {
    int newFingers = _fingers + delta;
    if (newFingers >= 0 && newFingers <= 5) {
      debugPrint("Fingers = $newFingers");
      setState(() => _fingers = newFingers);
    }
  }

  @override
  buildGameArea() {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ArrowButton(
                    icon: Icons.keyboard_arrow_up_rounded,
                    delta: 1,
                    color: Theme.of(context).colorScheme.primary,
                    changeN: _changeFingers,
                    quickChangeNStart: (_) {},
                    quickChangeNEnd: () {},
                    enabled: _fingers < 5,
                  ),
                  HandImage(_fingers, height: 150),
                  ArrowButton(
                    icon: Icons.keyboard_arrow_down_rounded,
                    delta: -1,
                    color: Theme.of(context).colorScheme.primary,
                    changeN: _changeFingers,
                    quickChangeNStart: (_) {},
                    quickChangeNEnd: () {},
                    enabled: _fingers > 0,
                  ),
                ],
              ),
            ),
            const Gap(),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buildNumberControls(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class HandImage extends StatelessWidget {
  static const _hands = [
    "assets/images/morra/zero.png",
    "assets/images/morra/one.png",
    "assets/images/morra/two.png",
    "assets/images/morra/three.png",
    "assets/images/morra/four.png",
    "assets/images/morra/five.png",
  ];

  final int fingers;
  final double? height;
  final double padding;

  const HandImage(this.fingers, {super.key, this.height, this.padding = 0});

  @override
  build(context) {
    var raw = Image.asset(
      _hands[fingers],
      alignment: Alignment.topCenter,
      height: height,
    );
    var padded = (padding == 0)
        ? raw
        : Padding(
            padding: EdgeInsets.all(padding),
            child: raw,
          );
    return padded;
  }
}

class MorraOutcome extends OutcomeScreen {
  MorraOutcome({super.key}) : super(gameFeatures: morra);

  @override
  MorraOutcomeState createState() => MorraOutcomeState();
}

class MorraOutcomeState extends OutcomeScreenState<MorraMove> {
  static const _handsPadding = 10.0;

  late final _fingers = <int>[];
  late final _playerPerformances = <PlayerPerformance>[];

  @override
  initState() {
    super.initState();
    for (Player player in players) {
      _fingers.add(getMove(player).fingers);
      _playerPerformances.add(
        PlayerPerformance(
          player,
          primaryText: getMove(player).n.toString(),
        ),
      );
    }
  }

  @override
  Widget buildOutcome() => ListView(
        children: [
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            children: _fingers
                .map((fingers) => HandImage(fingers, padding: _handsPadding))
                .toList(),
          ),
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              children: [
                TextSpan(
                  text: "Totale dita: ",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                TextSpan(
                  text: _fingers.sum.toString(),
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const Gap(),
          ..._playerPerformances,
        ],
      );
}

class MorraMove extends ShotMove {
  static countFingers(Iterable<MorraMove> moves) =>
      moves.map((move) => move.fingers).sum;

  final int fingers;

  MorraMove({required super.time, required this.fingers, required super.n});

  @override
  int getPointsWith(Iterable<Move> allMoves) {
    int totalFingers = countFingers(allMoves.cast<MorraMove>());
    return (totalFingers - n).abs();
  }
}
