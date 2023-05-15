import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class OuijaBoard extends PositionComponent {
  int gridColumns;
  int gridRows;

  late final double cellWidth;
  late final double cellHeight;

  late final List<List<OuijaBoardCell>> _cells;

  final List<Offset> _leftNotches = [];
  final List<Offset> _rightNotches = [];
  final List<Offset> _topNotches = [];
  final List<Offset> _bottomNotches = [];

  Paint get paint => Paint()
    ..color = Colors.blueGrey.shade200
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  OuijaBoard({
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
        (column) => OuijaBoardCell(this, row, column),
      ),
    );
    debugPrint("cells: $_cells"); // TODO
  }
}

class OuijaBoardCell {
  final OuijaBoard board;
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

  OuijaBoardCell(this.board, this.row, this.column);

  @override
  operator ==(other) =>
      other is OuijaBoardCell && row == other.row && column == other.column;
}
