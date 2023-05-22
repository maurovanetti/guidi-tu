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

  final List<Offset> _leftNotches = [];
  final List<Offset> _rightNotches = [];
  final List<Offset> _topNotches = [];
  final List<Offset> _bottomNotches = [];

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
      (row) => List.generate(
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
}

class CustomBoardCell {
  final CustomBoard board;
  final int row;
  final int column;

  Vector2 get center =>
      board.topLeftPosition +
      Vector2(
        board.cellWidth * (column + 0.5),
        board.cellHeight * (row + 0.5),
      );

  @override
  int get hashCode => row * 1000 + column;

  CustomBoardCell(this.board, this.row, this.column);

  @override
  operator ==(other) =>
      other is CustomBoardCell && row == other.row && column == other.column;

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
