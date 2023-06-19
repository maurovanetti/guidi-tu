import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'straws_straw.dart';

class StrawsModule extends FlameGame {
  static const strawsCount = 50;

  final void Function(bool) setReady;

  late StrawsStraw _pickedStraw;
  get pickedStraw => _pickedStraw;

  StrawsModule({required this.setReady});

  @override
  backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    var sprite = await loadSprite('straws/straw.png');
    for (int i = 0; i < strawsCount; i++) {
      await add(_randomStraw(minLength: 100, sprite: sprite));
    }
  }

  StrawsStraw _randomStraw({
    required double minLength,
    required Sprite sprite,
  }) {
    var from = _randomPositionInRect(size, 0.9);
    var to = _randomPositionInRect(size, 0.9);
    var delta = to - from;
    var length = delta.length;
    if (length < minLength) {
      return _randomStraw(minLength: minLength, sprite: sprite);
    }
    // The minus sign compensates for the different reference system
    var angle = -delta.angleToSigned(Vector2(1, 0));
    return StrawsStraw(from, angle: angle, length: length, sprite: sprite);
  }

  static Vector2 _randomPositionInRect(Vector2 size, double safeArea) {
    var offset = (1.0 - safeArea) / 2;
    safeRandom() => offset + safeArea * Random().nextDouble();
    return Vector2(
      // ignore: prefer-moving-to-variable
      size.x * safeRandom(),
      // ignore: prefer-moving-to-variable
      size.y * safeRandom(),
    );
  }
}
