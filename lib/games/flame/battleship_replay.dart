import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'battleship_module.dart';

export 'battleship_bomb.dart';
export 'battleship_item.dart';
export 'battleship_ship.dart';

class BattleshipReplay extends FlameGame {
  late final BattleshipBoard board;

  @override
  Color backgroundColor() => Colors.blue.shade900;

  @override
  Future<void> onLoad() async {
    int gridColumns = BattleshipModule.gridColumns;
    int gridRows = BattleshipModule.gridRows;
    double padding = size.x * 0.05;
    // ignore: no-equal-arguments
    Rect grid = Rect.fromLTWH(padding, padding, size.x * 0.9, size.y * 0.9);
    board = BattleshipBoard(
      rect: grid,
      gridColumns: gridColumns,
      gridRows: gridRows,
    );
    await add(board);
  }
}
