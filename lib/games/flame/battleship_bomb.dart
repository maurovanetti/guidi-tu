import 'package:flame/components.dart';

import 'battleship_board.dart';
import 'battleship_item.dart';

class BattleshipBomb extends BattleshipItem {
  BattleshipBomb(
    Vector2 position, {
    required super.board,
  }) : super(
          'battleship/bomb.png',
          position,
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'bomb',
    };
  }

  static BattleshipBomb createOn(
    BattleshipBoard newBoard,
    BattleshipBoardCell cell,
  ) {
    var newCell = newBoard.cellAt(cell.row, cell.column);
    return BattleshipBomb(
      newCell.center,
      board: newBoard,
    );
  }
}
