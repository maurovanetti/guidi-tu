import 'dart:math';

import 'package:flame/components.dart';

import 'battleship_module.dart';
import 'custom_sprite_component.dart';

class BattleshipShip extends DraggableCustomSpriteComponent<BattleshipModule> {
  BattleshipShip(Vector2 position,
      {required Vector2 cellSize, int cellLength = 1, bool vertical = false})
      : super(
          'battleship/short_ship.png',
          position,
          size: Vector2(cellSize.x * cellLength.toDouble(), cellSize.y),
          elevation: 8,
          // Even if it spans more cells, it's anchored at the center of the 1st
          anchor: Anchor(0.5 / cellLength, 0.5),
        ) {
    if (vertical) {
      angle = -pi / 2;
    }
    if (Random().nextBool()) {
      angle += pi;
      anchor = Anchor(1 - anchor.x, 0.5);
    }
    snapRule =
        SnapRule(spots: [position]); // Snaps back to its initial position
  }
}
