import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'battleship_board.dart';
import 'battleship_ship.dart';
import 'custom_sprite_component.dart';

class BattleshipModule extends FlameGame with HasDraggables {
  @override
  Color backgroundColor() => Colors.blue.shade900;

  @override
  Future<void> onLoad() async {
    int gridColumns = 5;
    int gridRows = 5;
    double padding = size.x * 0.02;
    Rect grid = Rect.fromLTWH(padding, padding, size.x * 0.75, size.y * 0.75);
    var board = BattleshipBoard(
      rect: grid,
      gridColumns: gridColumns,
      gridRows: gridRows,
    );
    var shipInitialPosition = Vector2(
      padding + board.cellWidth / 2,
      size.y - padding - board.cellHeight / 2,
    );
    var smallShip = BattleshipShip(
      shipInitialPosition,
      cellSize: board.cellSize,
      cellLength: 1,
      vertical: false,
    );
    var largeShip = BattleshipShip(
      shipInitialPosition + Vector2(board.cellWidth * 2, 0),
      cellSize: board.cellSize,
      cellLength: 2,
      vertical: true,
    );
    for (var ship in [smallShip, largeShip]) {
      ship.snapRule = SnapRule(
        spots: board.cellCenters, // Snaps to the center of each cell
        fallbackSpot: ship.position.clone(),
        maxSnapDistance: board.cellSize.length / 2,
      );
    }
    await add(board);
    await add(smallShip);
    await add(largeShip);
  }
}
