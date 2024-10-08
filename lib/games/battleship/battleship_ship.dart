import 'package:flame/components.dart';

import 'battleship_board.dart';
import 'battleship_item.dart';

class BattleshipShip extends BattleshipItem {
  BattleshipShip(
    Vector2 position, {
    required super.board,
    super.cellSpan = 1,
    super.isVertical = false,
  }) : super(
          BattleshipShip.getAssetPath(cellSpan, isVertical: isVertical),
          position,
        );

  @override
  Map<String, dynamic> toJson() {
    return {'cellSpan': cellSpan, 'isVertical': isVertical, 'type': 'ship'};
  }

  bool isHit({
    required BattleshipBoardCell shipCell,
    required BattleshipBoardCell bombCell,
  }) {
    return isVertical
        ? bombCell.column == shipCell.column &&
            bombCell.row >= shipCell.row &&
            bombCell.row < shipCell.row + cellSpan
        : bombCell.row == shipCell.row &&
            bombCell.column >= shipCell.column &&
            bombCell.column < shipCell.column + cellSpan;
  }

  Set<BattleshipBoardCell> cells(BattleshipBoardCell pivot) {
    Set<BattleshipBoardCell> cells = {pivot};
    for (var i = 1, cell = pivot; i < cellSpan; i++) {
      cell = (isVertical ? cell.below() : cell.right()) as BattleshipBoardCell;
      final wasAdded = cells.add(cell);
      assert(wasAdded, "Error in ship cells");
    }
    return cells;
  }

  static String getAssetPath(int cellSpan, {required bool isVertical}) {
    if (cellSpan == 1) {
      return 'battleship/duck/Naval_Papera';
    }
    if (isVertical) {
      return 'battleship/buoy/Naval_Faro';
    }
    // ignore: prefer-returning-conditional-expressions
    return 'battleship/boat/Game_Naval_nave';
  }

  BattleshipShip copyOn(BattleshipBoard newBoard, BattleshipBoardCell cell) {
    var newCell = newBoard.cellAt(cell.row, cell.column);
    return BattleshipShip(
      newCell.center,
      board: newBoard,
      cellSpan: cellSpan,
      isVertical: isVertical,
    );
  }
}
