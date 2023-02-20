import 'dart:math';

import 'package:flame/components.dart';

import 'battleship_board.dart';
import 'battleship_module.dart';
import 'custom_sprite_component.dart';

abstract class BattleshipItem
    extends DraggableCustomSpriteComponent<BattleshipModule> {
  final int cellSpan;
  final bool isVertical;

  BattleshipItem(
    String assetPath,
    Vector2 position, {
    required BattleshipBoard board,
    this.cellSpan = 1,
    this.isVertical = false,
    bool flipped = false,
  }) : super(
          assetPath,
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
    if (flipped) {
      // Directly flipping it would break the consistence of the shadow
      angle += pi;
      anchor = Anchor(1 - anchor.x, 0.5);
    }
    snapRule = SnapRule(
      // Snaps to the center of each cell
      spots: board.cellCenters(
        rightmostColumnsSkipped: isVertical ? 0 : cellSpan - 1,
        bottomRowsSkipped: isVertical ? cellSpan - 1 : 0,
      ),
      // Snaps back to its initial position as a fallback
      fallbackSpot: position.clone(),
      // Twice the required amount, but this makes it easier to snap
      maxSnapDistance: board.cellSize.length,
    );
    onSnap = () => board.placeItem(this);
    onUnsnap = () {
      board.removeItem(this);
      return true;
    };
    board.itemsCount++;
  }

  Map<String, dynamic> toJson();
}
