import 'dart:async';
import 'dart:math';

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
    var smallShip = BattleshipShip(
      Vector2(
        size.x - padding - board.cellWidth / 2,
        size.y - padding - board.cellHeight / 2,
      ),
      cellSize: board.cellSize,
      cellSpan: 1,
      isVertical: Random().nextBool(),
    );
    var mediumShip = BattleshipShip(
      Vector2(
        size.x - padding - board.cellWidth / 2,
        padding + board.cellHeight / 2,
      ),
      cellSize: board.cellSize,
      cellSpan: 2,
      isVertical: true,
    );
    var largeShip = BattleshipShip(
      Vector2(
        padding + board.cellWidth / 2,
        size.y - padding - board.cellHeight / 2,
      ),
      cellSize: board.cellSize,
      cellSpan: 3,
      isVertical: false,
    );
    await add(board);
    for (var ship in [smallShip, mediumShip, largeShip]) {
      ship.snapRule = SnapRule(
        spots: board.cellCenters(
          rightmostColumnsSkipped: ship.isVertical ? 0 : ship.cellSpan - 1,
          bottomRowsSkipped: ship.isVertical ? ship.cellSpan - 1 : 0,
        ), // Snaps to the center of each cell
        fallbackSpot: ship.position.clone(),
        maxSnapDistance: board.cellSize.length / 2,
      );
      await add(ship);
    }
  }
}
