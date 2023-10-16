import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BoulesDragProjection extends RectangleComponent {
  final Vector2 origin;
  final PositionComponent target;

  static final _axis = Vector2(0, 1);
  static const _rotationOffset = pi * (5 / 4);

  BoulesDragProjection({
    required this.origin,
    required this.target,
  }) : super(
          position: target.position,
          anchor: Anchor.topLeft,
          // ignore: no-magic-number
          paint: Paint()..color = Colors.white.withOpacity(0.15),
          // ignore: no-magic-number
          size: Vector2(10000, 10000),
          priority: -100,
        );

  @override
  onLoad() {
    target.position.addListener(_onTargetMoved);
    _onTargetMoved();
    // ignore: avoid-async-call-in-sync-function
    super.onLoad();
  }

  void _onTargetMoved() {
    if (target.position.isNaN) {
      return;
    }
    position = target.position;
    angle = _rotationOffset - (position - origin).angleToSigned(_axis);
  }
}
