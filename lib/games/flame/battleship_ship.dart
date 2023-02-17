import 'package:flame/components.dart';

import 'battleship_module.dart';
import 'custom_sprite_component.dart';

class BattleshipShip extends DraggableCustomSpriteComponent<BattleshipModule> {
  BattleshipShip(Vector2 position)
      : super(
          'battleship/short_ship.png',
          position,
        ) {
    snapRule = SnapRule(
        spots: [position, position / 2]); // Snaps back to its initial position
  }
}
