import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '/games/flame/custom_sprite_component.dart';
import 'boules_bowl.dart';
import 'boules_module.dart';

class BoulesTarget extends CustomSpriteComponent<BoulesModule> {
  final Vector2 origin;
  final Color referenceColor;

  late final BoulesArrowTrunk _trunk;

  static final _rightAxis = Vector2(1, 0);

  BoulesTarget(
    Vector2 position, {
    required this.origin,
    required this.referenceColor,
  }) : super(
          'boules/target.png',
          position,
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
    return super.onLoad();
  }

  @override
  void update(double dt) {
    Vector2 delta = position - origin;
    transform.angle = -delta.angleTo(_rightAxis);
    scale.x = clampDouble(delta.length / 10, 4 / 5, 3 / 2);
    _trunk.resize(delta.length / scale.x);
    super.update(dt);
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
