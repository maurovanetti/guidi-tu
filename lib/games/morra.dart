import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:guidi_tu/common/player.dart';
import 'package:guidi_tu/common/widget_keys.dart';

import '../common/move.dart';
import '/common/game_features.dart';
import '/common/gap.dart';
import '/games/turn_play.dart';
import '../common/turn_aware.dart';
import 'game_area.dart';
import 'outcome_screen.dart';
import 'shot.dart';

class Morra extends TurnPlay {
  Morra() : super(key: morraWidgetKey, gameFeatures: morra);

  @override
  createState() => TurnPlayState<MorraMove>();
}

class MorraGameArea extends GameArea<MorraMove> {
  MorraGameArea({
    super.key,
    required super.setReady,
    required MoveReceiver moveReceiver,
  }) : super(
          gameFeatures: morra,
          moveReceiver: moveReceiver as MoveReceiver<MorraMove>,
        );

  @override
  createState() => MorraGameAreaState();
}

class MorraGameAreaState extends ShotGameAreaState<MorraMove> {
  static const handImageHeight = 150.0;

  int _fingers = 0;

  @override
  initState() {
    super.initState();
    _fingers = 0;
  }

  void _changeFingers(int delta) {
    int newFingers = _fingers + delta;
    if (newFingers >= 0 && newFingers <= 5) {
      debugPrint("Fingers = $newFingers");
      setState(() => _fingers = newFingers);
    }
  }

  @override
  MorraMove getMove() => MorraMove(fingers: _fingers, n: n);

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).colorScheme.primary;
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
                    color: primaryColor,
                    changeN: _changeFingers,
                    quickChangeNStart: (_) {},
                    quickChangeNEnd: () {},
                    enabled: _fingers < 5,
                  ),
                  HandImage(_fingers, height: handImageHeight),
                  ArrowButton(
                    icon: Icons.keyboard_arrow_down_rounded,
                    delta: -1,
                    color: primaryColor,
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
              child: ShotControls(
                n: n,
                stretched: false,
                shotState: this,
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
    return (padding == 0)
        ? raw
        : Padding(padding: EdgeInsets.all(padding), child: raw);
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
    for (var playerIndex in TurnAware.turns) {
      var player = players[playerIndex];
      _fingers.add(getMove(player).fingers);
      _playerPerformances.add(
        PlayerPerformance(
          player,
          primaryText: getMove(player).n.toString(),
        ),
      );
    }
    super.initState();
  }

  @override
  void initOutcome() {
    var textTheme = Theme.of(context).textTheme;
    outcomeWidget = ListView(
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
                style: textTheme.headlineLarge,
              ),
              TextSpan(
                text: _fingers.sum.toString(),
                style: textTheme.headlineLarge?.copyWith(
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
}

class MorraMove extends ShotMove {
  final int fingers;

  MorraMove({required this.fingers, required super.n});

  static countFingers(Iterable<RecordedMove<MorraMove>> moves) =>
      moves.map((rm) => rm.move.fingers).sum;

  @override
  int getPointsFor(Player player, Iterable<RecordedMove> allMoves) {
    int totalFingers = countFingers(allMoves.cast<RecordedMove<MorraMove>>());
    return (totalFingers - n).abs();
  }
}
