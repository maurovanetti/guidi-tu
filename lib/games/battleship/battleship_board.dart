import 'package:flutter/material.dart';

import '../flame/custom_board.dart';
import '/common/common.dart';
import 'battleship_item.dart';

class BattleshipBoard extends CustomBoard<BattleshipBoardCell>
    with CustomNotifier {
  int itemsCount = 0;

  // This is the same information as _cells, but in a different format more
  // suitable for registering the player's moves.
  final placedItems = <BattleshipItem, BattleshipBoardCell>{};

  bool get isEmpty => placedItems.isEmpty;

  bool get isFull => placedItems.length == itemsCount;

  @override
  Paint get paint => super.paint
    ..color = Colors.blue.shade200
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  BattleshipBoard({
    required super.rect,
    required super.gridColumns,
    required super.gridRows,
  });

  bool placeItem(BattleshipItem item) {
    var cell = cellOn(item.position);
    if (cell.isAvailableFor(item)) {
      for (int i = 0; i < item.cellSpan; i++) {
        if (item.isVertical) {
          cellAt(cell.row + i, cell.column).owner = item;
        } else {
          cellAt(cell.row, cell.column + i).owner = item;
        }
      }
      placedItems[item] = cell;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeItem(BattleshipItem item) {
    for (int row = 0; row < gridRows; row++) {
      for (int column = 0; column < gridColumns; column++) {
        var cell = cellAt(row, column);
        if (cell.owner == item) {
          cell.owner = null;
        }
      }
    }
    if (placedItems.remove(item) != null) {
      notifyListeners();
    }
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> itemsAsList = [];
    for (var entry in placedItems.entries) {
      var item = entry.key;
      var cell = entry.value;
      itemsAsList.add({
        'column': cell.column,
        'item': item.toJson(),
        'row': cell.row,
      });
    }
    return {
      'gridColumns': gridColumns,
      'gridRows': gridRows,
      'items': itemsAsList,
    };
  }

  @override
  BattleshipBoardCell handleCreateCell(int row, int column) =>
      BattleshipBoardCell(this, row, column);
}

// ignore: prefer-overriding-parent-equality
class BattleshipBoardCell extends CustomBoardCell {
  @override
  final BattleshipBoard board;
  BattleshipItem? owner;

  BattleshipBoardCell(this.board, super.row, super.column);

  bool isAvailableFor(BattleshipItem item) {
    if (owner != null) {
      return false;
    }
    if (item.isVertical) {
      if (row + item.cellSpan > board.gridRows) {
        return false;
      }
      for (int i = 0; i < item.cellSpan; i++) {
        if (board.cellAt(row + i, column).owner != null) {
          return false;
        }
      }
    } else {
      if (column + item.cellSpan > board.gridColumns) {
        return false;
      }
      for (int i = 0; i < item.cellSpan; i++) {
        if (board.cellAt(row, column + i).owner != null) {
          return false;
        }
      }
    }
    return true;
  }
}
