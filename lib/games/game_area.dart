import 'package:flutter/material.dart';

import '/common/common.dart';

abstract class GameArea<T extends Move> extends StatefulWidget {
  final GameFeatures gameFeatures;
  final void Function(bool) setReady;
  final MoveReceiver<T> moveReceiver;

  const GameArea({
    super.key,
    required this.gameFeatures,
    required this.setReady,
    required this.moveReceiver,
  });

  @override
  GameAreaState createState();
}

abstract class GameAreaState<T extends Move> extends State<GameArea<T>>
    with MoveProvider<T> {
  @override
  void initState() {
    super.initState();
    addReceiver(widget.moveReceiver);
  }
}
