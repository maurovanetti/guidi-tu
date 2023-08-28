import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/games/flame/custom_sprite_component.dart';
import 'boules_bowl.dart';
import 'boules_module.dart';

class BoulesArrowHead extends CustomSpriteComponent<BoulesModule> {
  final Vector2 origin;
  final PositionComponent target;
  final Color referenceColor;

  late final BoulesArrowTrunk _trunk;

  static final _rightAxis = Vector2(1, 0);

  BoulesArrowHead({
    required this.origin,
    required this.target,
    required this.referenceColor,
  }) : super(
          'boules/target.png',
          target.position,
          hasShadow: false,
          elevation: 0,
          size: Vector2(2, 3),
          color: getColor(referenceColor),
        ) {
    priority = -1;
  }

  static getColor(Color c) => c.brighten(2 / 3);

  @override
  Future<void> onLoad() {
    _trunk = BoulesArrowTrunk(
      Vector2(1 / 10, height / 2),
      color: getColor(referenceColor),
    );
    add(_trunk);
    target.position.addListener(_onTargetMoved);
    _onTargetMoved();
    return super.onLoad();
  }

  void _onTargetMoved() {
    if (target.position.isNaN) {
      return;
    }
    Vector2 delta = target.position - origin;
    position = origin + (delta * 2 / 3);
    Vector2 arrow = position - origin;
    transform.angle = -arrow.angleTo(_rightAxis);
    scale.x = clampDouble(arrow.length / 10, 4 / 5, 3 / 2);
    _trunk.resize(arrow.length / scale.x);
  }
}

class BoulesArrowTrunk extends RectangleComponent {
  static const thickness = BoulesBowl.radius * (3 / 5);
  late double _initialScaleY;

  BoulesArrowTrunk(Vector2 position, {required Color color})
      : super(
          position: position,
          anchor: Anchor.topCenter,
          angle: pi / 2,
          paint: Paint()..color = color,
          size: Vector2(thickness, 1),
        ) {
    _initialScaleY = scale.y;
  }

  void resize(double length) {
    scale.y = _initialScaleY * length;
  }
}
