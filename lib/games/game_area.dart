import 'package:flutter/material.dart';

import '/common/common.dart';

abstract class GameArea<T extends Move> extends StatefulWidget {
  const GameArea({
    super.key,
    required this.gameFeatures,
    required this.onChangeReady,
    required this.moveReceiver,
    required this.startTime,
  });

  final GameFeatures gameFeatures;
  final DateTime startTime; // Only used in "synchronized" games like Stopwatch
  final OnChangeReady onChangeReady;
  final MoveReceiver<T> moveReceiver;

  @override
  GameAreaState createState();
}

abstract class GameAreaState<T extends Move> extends State<GameArea<T>>
    with MoveProvider<T>, Localized {
  @override
  void initState() {
    super.initState();
    addReceiver(widget.moveReceiver);
  }
}
