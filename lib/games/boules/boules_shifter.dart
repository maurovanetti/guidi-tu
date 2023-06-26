import 'package:flame/components.dart';

import '/games/flame/custom_sprite_component.dart';

class BoulesShifter extends DraggableCustomSpriteComponent {
  BoulesShifter(Vector2 position)
      : super(
          'boules/shifter.png',
          position,
          hasShadow: false,
          extraElevationWhileDragged: 0,
        ) {
    priority = 2;
  }
}
