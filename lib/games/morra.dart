import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/screens/outcome_screen.dart';
import '/screens/turn_play_screen.dart';
import 'game_area.dart';
import 'shot.dart';

class Morra extends TurnPlayScreen {
  Morra() : super(key: WidgetKeys.morra, gameFeatures: morra);

  @override
  createState() => TurnPlayState<MorraMove>();
}

class MorraGameArea extends GameArea<MorraMove> {
  MorraGameArea({
    super.key,
    required super.setReady,
    required MoveReceiver moveReceiver,
    required super.startTime,
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
  void didChangeDependencies() {
    for (var hand in HandImage.hands) {
      precacheImage(AssetImage(hand), context);
    }
    super.didChangeDependencies();
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
  static const _path = "assets/images/morra/hands";

  static const hands = [
    "$_path/zero.png",
    "$_path/one.png",
    "$_path/two.png",
    "$_path/three.png",
    "$_path/four.png",
    "$_path/five.png",
  ];

  final int fingers;
  final double? height;
  final double padding;
  late final Player player;

  HandImage(
    this.fingers, {
    super.key,
    this.height,
    this.padding = 0,
    Player? player,
  }) {
    this.player = player ?? Player.none;
  }

  // The alignment details depend on the actual hand image features.
  static final _iconAlignment = AlignmentGeometry.lerp(
    Alignment.bottomCenter,
    Alignment.bottomRight,
    0.4,
  )!;

  @override
  build(context) {
    var raw = Image.asset(
      hands[fingers],
      alignment: Alignment.topCenter,
      height: height,
    );
    return (padding == 0)
        ? raw
        : Padding(
            padding: EdgeInsets.all(padding),
            child: Stack(
              alignment: _iconAlignment,
              children: [
                raw,
                PlayerIcon.color(player),
              ],
            ),
          );
  }
}

class MorraOutcome extends OutcomeScreen {
  MorraOutcome({super.key}) : super(gameFeatures: morra);

  @override
  MorraOutcomeState createState() => MorraOutcomeState();
}

class MorraOutcomeState extends OutcomeScreenState<MorraMove> {
  static const _handsPadding = 10.0;

  late final LinkedHashMap<Player, int> _fingers = LinkedHashMap<Player, int>();
  late final _playerPerformances = <PlayerPerformance>[];

  @override
  initState() {
    for (var playerIndex in TurnAware.turns) {
      var player = players[playerIndex];
      _fingers[player] = (getMove(player).fingers);
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
          children: _fingers.entries
              .map((fingers) => HandImage(
                    fingers.value,
                    padding: _handsPadding,
                    player: fingers.key,
                  ))
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
                text: _fingers.values.sum.toString(),
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
