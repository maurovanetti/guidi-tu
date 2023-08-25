import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

abstract class CustomBoard<T extends CustomBoardCell>
    extends PositionComponent {
  int gridColumns;
  int gridRows;

  late final double cellWidth;
  late final double cellHeight;
  late final List<List<T>> _cells;

  final _leftNotches = <Offset>[];
  final _rightNotches = <Offset>[];
  final _topNotches = <Offset>[];
  final _bottomNotches = <Offset>[];

  Vector2 get cellSize => Vector2(cellWidth, cellHeight);

  Paint get paint => Paint();

  CustomBoard({
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
          (row) =>
          List.generate(
            gridColumns,
                (column) => createCell(row, column),
          ),
    );
  }

  T createCell(int row, int column);

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

  T cellAt(int row, int column) => _cells[row][column];

  T cellOn(Vector2 centerPosition) {
    var row = (centerPosition.y - topLeftPosition.y) ~/ cellHeight;
    var column = (centerPosition.x - topLeftPosition.x) ~/ cellWidth;
    return cellAt(row, column);
  }

  Iterable<Vector2> cellCenters({
    int leftmostColumnsSkipped = 0,
    int topRowsSkipped = 0,
    int rightmostColumnsSkipped = 0,
    int bottomRowsSkipped = 0,
  }) sync* {
    for (int row = topRowsSkipped; row < gridRows - bottomRowsSkipped; row++) {
      for (int column = leftmostColumnsSkipped;
      column < gridColumns - rightmostColumnsSkipped;
      column++) {
        var cellCenter = topLeftPosition +
            Vector2(cellWidth * (column + 0.5), cellHeight * (row + 0.5));
        yield cellCenter;
      }
    }
  }
}

abstract class CustomBoardCell {
  final int row;
  final int column;

  CustomBoard get board;

  Vector2 get center =>
      board.topLeftPosition +
          Vector2(
            board.cellWidth * (column + 0.5),
            board.cellHeight * (row + 0.5),
          );

  @override
  int get hashCode => row * 1000 + column;

  @override
  operator ==(Object other) =>
      other is CustomBoardCell && row == other.row && column == other.column;

  const CustomBoardCell(this.row, this.column);

  CustomBoardCell below() {
    return board.cellAt(row + 1, column);
  }

  CustomBoardCell above() {
    return board.cellAt(row - 1, column);
  }

  CustomBoardCell left() {
    return board.cellAt(row, column - 1);
  }

  CustomBoardCell right() {
    return board.cellAt(row, column + 1);
  }
}
