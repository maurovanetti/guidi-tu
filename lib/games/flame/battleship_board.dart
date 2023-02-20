import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import 'battleship_item.dart';

class BattleshipBoard extends PositionComponent {
  int gridColumns;
  int gridRows;

  late final double cellWidth;
  late final double cellHeight;

  late List<List<BattleshipBoardCell>> _cells;

  Vector2 get cellSize => Vector2(cellWidth, cellHeight);

  final List<Offset> _leftNotches = [];
  final List<Offset> _rightNotches = [];
  final List<Offset> _topNotches = [];
  final List<Offset> _bottomNotches = [];

  BattleshipBoard({
    required Rect rect,
    required this.gridColumns,
    required this.gridRows,
  }) : super(
          position: rect.center.toVector2(),
          size: rect.size.toVector2(),
          anchor: Anchor.center,
        ) {
    cellWidth = rect.width / gridColumns;
    cellHeight = rect.height / gridRows;
    for (double y = 0; y <= rect.height; y += cellHeight) {
      _leftNotches.add(Offset(0, y));
      _rightNotches.add(Offset(rect.width, y));
    }
    for (double x = 0; x <= rect.width; x += cellWidth) {
      _topNotches.add(Offset(x, 0));
      _bottomNotches.add(Offset(x, rect.height));
    }
    _cells = List.generate(
      gridRows,
      (row) => List.generate(
        gridColumns,
        (column) => BattleshipBoardCell(this, row, column),
      ),
    );
  }

  Paint get paint => Paint()
    ..color = Colors.blue.shade200
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  Iterable<Vector2> cellCenters(
      {int leftmostColumnsSkipped = 0,
      int topRowsSkipped = 0,
      int rightmostColumnsSkipped = 0,
      int bottomRowsSkipped = 0}) sync* {
    for (int row = topRowsSkipped; row < gridRows - bottomRowsSkipped; row++) {
      for (int column = leftmostColumnsSkipped;
          column < gridColumns - rightmostColumnsSkipped;
          column++) {
        var cellCenter = topLeftPosition +
            Vector2(
              cellWidth * (column + 0.5),
              cellHeight * (row + 0.5),
            );
        yield cellCenter;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    for (int i = 0; i < _leftNotches.length; i++) {
      canvas.drawLine(_leftNotches[i], _rightNotches[i], paint);
    }
    for (int i = 0; i < _topNotches.length; i++) {
      canvas.drawLine(_topNotches[i], _bottomNotches[i], paint);
    }
    super.render(canvas);
  }

  BattleshipBoardCell cellAt(int row, int i) => _cells[row][i];

  BattleshipBoardCell cellOn(Vector2 centerPosition) {
    var row = (centerPosition.y - topLeftPosition.y) ~/ cellHeight;
    var column = (centerPosition.x - topLeftPosition.x) ~/ cellWidth;
    return cellAt(row, column);
  }

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
      return true;
    }
    return false;
  }

  void removeItem(BattleshipItem ship) {
    for (int row = 0; row < gridRows; row++) {
      for (int column = 0; column < gridColumns; column++) {
        var cell = cellAt(row, column);
        if (cell.owner == ship) {
          cell.owner = null;
        }
      }
    }
  }
}

class BattleshipBoardCell {
  final BattleshipBoard board;
  final int row;
  final int column;
  BattleshipItem? owner;

  BattleshipBoardCell(this.board, this.row, this.column);

  Vector2 get center =>
      board.topLeftPosition +
      Vector2(
        board.cellWidth * (column + 0.5),
        board.cellHeight * (row + 0.5),
      );

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
