import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '/games/flame/custom_sprite_component.dart';

class SteadyHandPlatform extends CustomSpriteComponent {
  final double radius;

  static const shortStepDurationInSeconds = 3.0;

  get shortStep => LinearEffectController(shortStepDurationInSeconds);
  get longStep => LinearEffectController(shortStepDurationInSeconds * 2);

  SteadyHandPlatform(Vector2 position, {required this.radius})
      : super(
          'steady_hand/platform.png',
          position,
          anchor: Anchor.center,
          size: Vector2.all(radius * 2),
          hasShadow: false,
        ) {
    priority = 0;
  }

  bool isUnder(Body item) {
    final distance = position.distanceTo(item.position);
    // This works because the platform is a circle
    return distance < radius * scale.x;
  }

  @override
  Future<void> onLoad() {
    var waitThenShrink = SequenceEffect(
      [
        MoveEffect.by(Vector2.zero(), longStep), // wait
        ScaleEffect.by(Vector2.all(0.9), longStep), // shrink
      ],
      onComplete: _cycle,
    );
    add(waitThenShrink);
    return super.onLoad();
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
