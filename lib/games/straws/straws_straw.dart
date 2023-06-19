import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';

import 'straws_module.dart';

class StrawsStraw extends NineTileBoxComponent
    with HasGameReference<StrawsModule> {
  bool _picked = false;

  get length => size.x;

  @override
  int get hashCode => Object.hash(position, angle, length);

  bool get picked => _picked;
  set picked(bool value) {
    if (value && !_picked) {
      // --> on
      decorator.addLast(PaintDecorator.tint(Colors.white));
    } else if (!value && _picked) {
      // --> off
      decorator.removeLast();
    }
    _picked = value;
  }

  StrawsStraw(
    Vector2 from, {
    required double angle,
    required double length,
    required Sprite sprite,
  }) : super(
          nineTileBox: NineTileBox(sprite),
          position: from,
          angle: angle,
          anchor: Anchor.centerLeft,
          size: Vector2(length, 10),
        );

  factory StrawsStraw.fromJson(Map<String, dynamic> json, Sprite sprite) {
    return StrawsStraw(
      Vector2(
        json['from']['x'],
        json['from']['y'],
      ),
      angle: json['angle'],
      length: json['length'],
      sprite: sprite,
    );
  }

  Map<String, dynamic> toJson() => {
        'from': {
          'x': position.x,
          'y': position.y,
        },
        'angle': angle,
        'length': length,
      };

  @override
  operator ==(other) =>
      other is StrawsStraw &&
      other.position == position &&
      other.angle == angle &&
      other.length == length;
}
