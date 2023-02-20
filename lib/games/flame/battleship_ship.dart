import 'dart:math';

import 'package:flame/components.dart';

import 'battleship_board.dart';
import 'battleship_module.dart';
import 'custom_sprite_component.dart';

class BattleshipShip extends DraggableCustomSpriteComponent<BattleshipModule> {
  final int cellSpan;
  final bool isVertical;

  BattleshipShip(
    Vector2 position, {
    required BattleshipBoard board,
    this.cellSpan = 1,
    this.isVertical = false,
  }) : super(
          'battleship/short_ship.png',
          position,
          size:
              Vector2(board.cellSize.x * cellSpan.toDouble(), board.cellSize.y),
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
    onSnap = () => board.placeShip(this);
    onUnsnap = () {
      board.removeShip(this);
      return true;
    };
  }
}
