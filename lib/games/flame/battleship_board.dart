import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class BattleshipBoard extends PositionComponent {
  int gridColumns;
  int gridRows;

  late final double cellWidth;
  late final double cellHeight;

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
  }

  Paint get paint => Paint()
    ..color = Colors.blue.shade200
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  Iterable<Vector2> get cellCenters sync* {
    for (int row = 0; row < gridRows; row++) {
      for (int column = 0; column < gridColumns; column++) {
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
}
