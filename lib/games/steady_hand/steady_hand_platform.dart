import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '/games/flame/custom_sprite_component.dart';

class SteadyHandPlatform extends CustomSpriteComponent {
  final double radius;

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
    return distance < radius;
  }
}
