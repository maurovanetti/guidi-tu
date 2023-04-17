import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'battleship_module.dart';

export 'battleship_bomb.dart';
export 'battleship_item.dart';
export 'battleship_ship.dart';

class BattleshipReplay extends BattleshipModule {
  BattleshipReplay() : super(setReady: (_) {});

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

  BattleshipBomb importBomb(BattleshipBoardCell cell) {
    var bomb = BattleshipBomb.createOn(board, cell)..draggable = false;
    add(bomb);
    // Bombs are not "placed" on the board, just displayed over it, because
    // their places are potentially occupied by rival ships
    return bomb;
  }

  BattleshipShip importShip(BattleshipShip ship, BattleshipBoardCell cell) {
    var shipClone = ship.copyOn(board, cell)..draggable = false;
    add(shipClone);
    assert(board.placeItem(shipClone), "Ship import failed");
    return shipClone;
  }

  void clear() {
    for (Component child in children) {
      if (child is BattleshipItem) {
        board.removeItem(child);
        remove(child);
      }
    }
  }

  Future<void> importSink(BattleshipBoardCell cell) async {
    var itemOnCell = board.cellAt(cell.row, cell.column).owner;
    if (itemOnCell is BattleshipShip) {
      return itemOnCell.sink();
    }
  }
}
