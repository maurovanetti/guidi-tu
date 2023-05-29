import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../flame/custom_board.dart';

class OuijaBoard extends CustomBoard<OuijaBoardCell> {
  final int slots;

  @override
  Paint get paint => Paint()
    ..color = Colors.blueGrey.shade200
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  double get slotWidth => size.x / slots;
  double get slotHeight => cellHeight;
  Vector2 get slotSize => Vector2(slotWidth, slotHeight);

  OuijaBoard({
    required super.rect,
    required super.gridColumns,
    required super.gridRows,
    required this.slots,
  });

  @override
  OuijaBoardCell createCell(int row, int column) =>
      OuijaBoardCell(this, row, column);
}

class OuijaBoardCell extends CustomBoardCell {
  @override
  final OuijaBoard board;

  OuijaBoardCell(this.board, super.row, super.column);
}
