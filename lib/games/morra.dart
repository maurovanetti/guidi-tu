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

class MorraGameAreaState extends ShotGameAreaState<MorraMove>
    with Gendered, TeamAware {
  static const handImageHeight = 120.0;

  int _fingers = 3;

  @override
  initState() {
    super.initState();
    n = _fingers;
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
    for (var hand in [...HandImage.hands, ...HandImage.outlinedHands]) {
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
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          children: players
              .map((player) => HandImage(
                    player == TurnAware.currentPlayer
                        ? _fingers
                        : HandImage.unknown,
                    variant: player == TurnAware.currentPlayer
                        ? HandImageVariant.definedWithIcon
                        : HandImageVariant.undefinedWithIcon,
                    padding: HandImage._handsPadding,
                    player: player,
                  ))
              .toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ArrowButton(
                    assetPath: 'ui/up.png',
                    delta: 1,
                    color: primaryColor,
                    changeN: _changeFingers,
                    quickChangeNStart: (_) {},
                    quickChangeNEnd: () {},
                    enabled: _fingers < 5,
                  ),
                  HandImage(
                    _fingers,
                    height: handImageHeight,
                    variant: HandImageVariant.withNumber,
                  ),
                  ArrowButton(
                    assetPath: 'ui/down.png',
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
                caption: 'SOMMA =',
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

enum HandImageVariant {
  withNumber,
  definedWithIcon,
  undefinedWithIcon,
}

class HandImage extends StatefulWidget {
  HandImage(
    this.fingers, {
    super.key,
    this.height,
    this.padding = 0,
    required this.variant,
    Player? player,
  }) {
    assert(player != null || variant == HandImageVariant.withNumber);
    this.player = player ?? Player.none;
  }

  static const unknown = -1;
  static const _handsPadding = 10.0;
  static const _path = "assets/images/morra/hands";

  static const hands = [
    "$_path/zero.png",
    "$_path/one.png",
    "$_path/two.png",
    "$_path/three.png",
    "$_path/four.png",
    "$_path/five.png",
  ];

  static const outlinedHands = [
    "$_path/zero_outline.png",
    "$_path/one_outline.png",
    "$_path/two_outline.png",
    "$_path/three_outline.png",
    "$_path/four_outline.png",
    "$_path/five_outline.png",
  ];

  final int fingers;
  final double? height;
  final double padding;
  final HandImageVariant variant;
  late final Player player;

  @override
  createState() => HandImageState();
}

class HandImageState extends State<HandImage> with TickerProviderStateMixin {
  // When the hand is unknown, the animation is a frenzy of hands.
  static const _millisecondsPerFrame = 200;

  // The alignment details depend on the actual hand image features.
  static final _iconAlignment = AlignmentGeometry.lerp(
    Alignment.bottomLeft,
    Alignment.bottomRight,
    0.55,
  )!;

  AnimationController? _controller;

  @override
  initState() {
    super.initState();
    int n = HandImage.hands.length;
    if (widget.fingers == HandImage.unknown) {
      _controller = AnimationController(
        duration: Duration(milliseconds: _millisecondsPerFrame * n),
        lowerBound: 0,
        upperBound: n.toDouble(),
        vsync: this,
      )..repeat();
    }
  }

  // ignore: avoid-long-functions
  Widget _build(BuildContext context) {
    Color? color;
    switch (widget.variant) {
      case HandImageVariant.withNumber:
        color = null;
        break;
      case HandImageVariant.definedWithIcon:
        color = Colors.white;
        break;
      case HandImageVariant.undefinedWithIcon:
        color = Colors.grey[600];
        break;
    }
    var fingers = _controller?.value.floor() ?? widget.fingers;
    var pictures = widget.variant == HandImageVariant.definedWithIcon
        ? HandImage.outlinedHands
        : HandImage.hands;
    Widget raw = Image.asset(
      pictures[fingers],
      alignment: Alignment.topCenter,
      height: widget.height,
      color: color,
      semanticLabel: fingers.toString(),
    );
    var baseFontStyle = Theme.of(context).textTheme.bodyLarge;
    return Padding(
      padding: EdgeInsets.all(widget.padding),
      child: Stack(
        alignment: _iconAlignment,
        children: [
          raw,
          if (widget.variant case HandImageVariant.definedWithIcon)
            PlayerIcon.color(widget.player),
          if (widget.variant case HandImageVariant.withNumber)
            Text(
              widget.fingers.toString(),
              style: baseFontStyle?.copyWith(
                color: Colors.black.withOpacity(0.5),
                fontSize: (widget.height != null) ? widget.height! / 3 : null,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (widget.variant case HandImageVariant.undefinedWithIcon)
            Text(
              "?",
              style: baseFontStyle?.copyWith(
                color: Colors.white,
                fontSize: StyleGuide.iconSize * 2,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  @override
  dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller ?? const AlwaysStoppedAnimation(0),
      builder: (innerContext, child) => _build(innerContext),
    );
  }
}

class MorraOutcome extends OutcomeScreen {
  MorraOutcome({super.key}) : super(gameFeatures: morra);

  @override
  MorraOutcomeState createState() => MorraOutcomeState();
}

class MorraOutcomeState extends OutcomeScreenState<MorraMove> {
  late final _fingers = LinkedHashMap<Player, int>();
  late final _playerPerformances = <PlayerPerformance>[];

  @override
  initState() {
    super.initState();
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
                    variant: HandImageVariant.definedWithIcon,
                    player: fingers.key,
                    padding: HandImage._handsPadding,
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

  const MorraMove({required this.fingers, required super.n});

  static countFingers(Iterable<RecordedMove<MorraMove>> moves) =>
      moves.map((rm) => rm.move.fingers).sum;

  @override
  int getPointsFor(Player player, Iterable<RecordedMove> allMoves) {
    int totalFingers = countFingers(allMoves.cast<RecordedMove<MorraMove>>());
    return (totalFingers - n).abs();
  }
}
