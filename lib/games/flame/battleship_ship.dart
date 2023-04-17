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
          BattleshipShip.getAssetPath(cellSpan, isVertical),
          position,
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'ship',
      'cellSpan': cellSpan,
      'isVertical': isVertical,
    };
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
      cell = isVertical ? cell.below() : cell.right();
      assert(cells.add(cell), "Error in ship cells");
    }
    return cells;
  }

  static String getAssetPath(int cellSpan, bool isVertical) {
    if (cellSpan == 1) {
      return 'battleship/duck/Naval_Papera';
    }
    if (isVertical) {
      return 'battleship/buoy/Navale_Faro';
    }
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

  Future<void> sink() async {
    for (var i = 0; i < 7; i++) {
      visible = !visible;
      var _ = await Future.delayed(const Duration(milliseconds: 200));
    }
    visible = false;
  }
}
