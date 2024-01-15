import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class SteadyHandPlatform extends CircleComponent with HasGameRef {
  static const shortStepDurationInSeconds = 3.0;
  static final bluePaint = Paint()
    ..style = PaintingStyle.fill
    ..color = const Color(0xff4e61a6);

  get shortStep => LinearEffectController(shortStepDurationInSeconds);

  get longStep => LinearEffectController(shortStepDurationInSeconds * 2);

  SteadyHandPlatform(Vector2 position, {required super.radius})
      : super(
          position: position,
          anchor: Anchor.center,
          paint: bluePaint,
        ) {
    priority = 0;
  }

  @override
  Future<void> onLoad() async {
    var waitThenShrink = SequenceEffect(
      [
        MoveEffect.by(Vector2.zero(), longStep), // wait
        ScaleEffect.by(Vector2.all(0.9), longStep), // shrink
      ],
      onComplete: _cycle,
    );
    await add(waitThenShrink);
    await super.onLoad();
  }

  void _cycle() {
    var delta = (radius * 2) - scaledSize.x;
    var sequence = SequenceEffect(
      [
        MoveEffect.by(Vector2.all(-delta / 2), shortStep), // to NW
        MoveEffect.by(Vector2(delta, 0), shortStep), // to NE
        MoveEffect.by(Vector2(0, delta), shortStep), // to SE
        MoveEffect.by(Vector2(-delta, 0), shortStep), // to SW
        MoveEffect.by(Vector2(0, -delta), shortStep), // to NW
        MoveEffect.by(Vector2.all(delta / 2), shortStep), // to center
        ScaleEffect.by(Vector2.all(0.8), longStep), // shrink more
      ],
      onComplete: _cycle,
    );
    // ignore: avoid-async-call-in-sync-function
    add(sequence);
  }
}
