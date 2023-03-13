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

  static String getAssetPath(int cellSpan, bool isVertical) {
    if (cellSpan == 1) {
      return 'battleship/duck/Naval_Papera';
    }
    if (isVertical) {
      return 'battleship/buoy/Navale_Faro';
    }
    return 'battleship/short_ship.png';
  }
}
