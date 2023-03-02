import 'dart:async';

import 'package:flutter/material.dart';

import '../common/game_features.dart';
import '../common/turn_aware.dart';

abstract class GameArea extends StatefulWidget {
  final GameFeatures gameFeatures;
  final Widget child;
  final bool ready;
  final FutureOr<void> Function(Duration) onCompleteTurn;

  const GameArea({
    super.key,
    required this.gameFeatures,
    required this.child,
    this.ready = true,
    required this.onCompleteTurn,
  });

  @override
  GameAreaState createState();
}

abstract class GameAreaState<T extends Move> extends State<GameArea> {}
