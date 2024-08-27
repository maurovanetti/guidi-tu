import 'package:flame/components.dart';

import '/common/common.dart';
import '/games/flame/custom_sprite_component.dart';
import 'battleship_board.dart';
import 'battleship_module.dart';

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
    Player? player,
  }) : super(
          assetPath,
          stampAssetPath: player?.iconAssetPath(PlayerIconVariant.white),
          position,
          size: Vector2(board.cellSize.x, board.cellSize.y),
          elevation: 8,
        ) {
    // Basic size of a 1x1 ship, it will be scaled up in a moment if needed.
    size = Vector2(board.cellSize.x, board.cellSize.y);
    // Even if it spans more cells, it's anchored at the center of the 1st.
    if (isVertical) {
      size.y *= cellSpan;
      anchor = Anchor(0.5, 0.5 / cellSpan);
    } else {
      size.x *= cellSpan;
      anchor = Anchor(0.5 / cellSpan, 0.5);
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
    onSnap = () => board.tryPlaceItem(this);
    onUnsnap = () {
      board.removeItem(this);
      return true;
    };
    board.itemsCount++;
  }

  Map<String, dynamic> toJson();
}
