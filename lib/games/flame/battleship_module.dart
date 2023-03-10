import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'battleship_board.dart';
import 'battleship_bomb.dart';
import 'battleship_ship.dart';

export 'battleship_board.dart';
export 'battleship_bomb.dart';
export 'battleship_item.dart';
export 'battleship_ship.dart';

class BattleshipModule extends FlameGame with HasDraggables {
  late final BattleshipBoard board;

  final void Function(bool) setReady;

  BattleshipModule({required this.setReady});

  @override
  Color backgroundColor() => Colors.blue.shade900;

  @override
  Future<void> onLoad() async {
    int gridColumns = 5;
    int gridRows = 5;
    double padding = size.x * 0.02;
    // Same padding for left and top is not a mistake.
    // ignore: no-equal-arguments
    Rect grid = Rect.fromLTWH(padding, padding, size.x * 0.75, size.y * 0.75);
    board = BattleshipBoard(
      rect: grid,
      gridColumns: gridColumns,
      gridRows: gridRows,
    );
    await add(board);
    var smallShip = BattleshipShip(
      Vector2(
        size.x - padding - board.cellWidth / 2,
        size.y - padding - board.cellHeight / 2,
      ),
      cellSpan: 1,
      isVertical: false,
      board: board,
    );
    var mediumShip = BattleshipShip(
      Vector2(
        size.x - padding - board.cellWidth / 2,
        padding + board.cellHeight / 2,
      ),
      cellSpan: 2,
      isVertical: true,
      board: board,
    );
    var largeShip = BattleshipShip(
      Vector2(
        padding + board.cellWidth / 2,
        size.y - padding - board.cellHeight / 2,
      ),
      cellSpan: 3,
      isVertical: false,
      board: board,
    );
    for (var ship in [smallShip, mediumShip, largeShip]) {
      await add(ship);
    }
    var rightwardOneCell = Vector2(1, 0) * board.cellWidth;
    var downwardOneCell = Vector2(0, 1) * board.cellHeight;
    var rightOfLargeShip = largeShip.position + rightwardOneCell * 3;
    var belowMediumShip = mediumShip.position + downwardOneCell * 2;
    var bombPositions = [
      belowMediumShip + downwardOneCell,
      rightOfLargeShip,
      belowMediumShip,
      rightOfLargeShip + rightwardOneCell,
      belowMediumShip + downwardOneCell * 2,
    ];
    for (int i = 0; i < 5; i++) {
      var bomb = BattleshipBomb(
        bombPositions[i],
        board: board,
      );
      await add(bomb);
    }
    board.addListener(() {
      setReady(board.isFull);
    });
  }
}
