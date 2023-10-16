import 'package:equatable/equatable.dart';
import 'package:flame/components.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';

import 'straws_module.dart';

class StrawsStraw extends NineTileBoxComponent
    with HasGameReference<StrawsModule>, EquatableMixin {
  bool _picked = false;

  int get length => size.x.toInt();

  bool get picked => _picked;

  @override
  List<Object?> get props => [position, angle, length];

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
    required int length,
    required Sprite sprite,
  }) : super(
          nineTileBox: NineTileBox(sprite),
          position: from,
          angle: angle,
          anchor: Anchor.centerLeft,
          size: Vector2(length.toDouble(), 10),
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
        'angle': angle,
        'from': {
          'x': position.x,
          'y': position.y,
        },
        'length': length,
      };
}
