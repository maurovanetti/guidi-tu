import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'straws_straw.dart';

class StrawsModule extends FlameGame {
  static const strawsCount = 25;
  static const minStrawLengthRatio = 0.4; // as fraction of game area width

  final void Function(bool) setReady;

  final List<StrawsStraw> _straws = [];
  int _pickedStrawIndex = 0;
  StrawsStraw get pickedStraw => _straws[_pickedStrawIndex];

  StrawsModule({required this.setReady});

  @override
  backgroundColor() => Colors.transparent;

  @override
  Future<void> onLoad() async {
    var sprite = await loadSprite('straws/straw.png');
    for (int i = 0; i < strawsCount; i++) {
      var straw = _randomStraw(
        minLength: size.x * minStrawLengthRatio,
        sprite: sprite,
      );
      _straws.add(straw);
      if (i == 0) {
        pick(straw);
      }
      add(straw);
    }
  }

  void pick([StrawsStraw? straw]) {
    assert(_straws.isNotEmpty, "No straws to pick from");
    pickedStraw.picked = false;
    _pickedStrawIndex = straw == null
        ? (_pickedStrawIndex + 1) % _straws.length
        : _straws.indexOf(straw);
    pickedStraw.picked = true;
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
