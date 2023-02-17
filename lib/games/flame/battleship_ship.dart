import 'dart:math';

import 'package:flame/components.dart';

import 'battleship_module.dart';
import 'custom_sprite_component.dart';

class BattleshipShip extends DraggableCustomSpriteComponent<BattleshipModule> {
  final int cellSpan;
  final bool isVertical;

  BattleshipShip(Vector2 position,
      {required Vector2 cellSize, this.cellSpan = 1, this.isVertical = false})
      : super(
          'battleship/short_ship.png',
          position,
          size: Vector2(cellSize.x * cellSpan.toDouble(), cellSize.y),
          elevation: 8,
          // Even if it spans more cells, it's anchored at the center of the 1st
          anchor: Anchor(0.5 / cellSpan, 0.5),
        ) {
    if (isVertical) {
      angle = pi / 2;
    }
    if (Random().nextBool()) {
      // Flipping it would break the consistence of the shadow
      angle += pi;
      anchor = Anchor(1 - anchor.x, 0.5);
    }
    snapRule =
        SnapRule(spots: [position]); // Snaps back to its initial position
  }
}
