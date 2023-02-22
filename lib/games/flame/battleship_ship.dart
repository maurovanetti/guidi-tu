import 'dart:math';

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
          'battleship/short_ship.png', // TODO Images for different sizes
          position,
          flipped: Random().nextBool(),
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
    if (isVertical) {
      return bombCell.column == shipCell.column &&
          bombCell.row >= shipCell.row &&
          bombCell.row < shipCell.row + cellSpan;
    } else {
      return bombCell.row == shipCell.row &&
          bombCell.column >= shipCell.column &&
          bombCell.column < shipCell.column + cellSpan;
    }
  }
}
