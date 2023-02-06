import 'package:flutter/material.dart';

import '/common/game_features.dart';
import '/games/turn_play.dart';
import '../common/gap.dart';
import 'outcome_screen.dart';
import 'shot.dart';

class Morra extends TurnPlay {
  Morra({super.key}) : super(gameFeatures: morra);

  @override
  createState() => MorraState();
}

class MorraState extends ShotState {
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

  final _hands = [
    "assets/images/morra/zero.png",
    "assets/images/morra/one.png",
    "assets/images/morra/two.png",
    "assets/images/morra/three.png",
    "assets/images/morra/four.png",
    "assets/images/morra/five.png",
  ];

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
                  Image.asset(
                    _hands[_fingers],
                    alignment: Alignment.topCenter,
                    height: 150,
                  ),
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

class MorraOutcome extends OutcomeScreen {
  MorraOutcome({super.key}) : super(gameFeatures: largeShot);

  // Implement its OutcomeScreenState subclass
}
