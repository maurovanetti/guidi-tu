import 'package:flame/components.dart';

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
}
