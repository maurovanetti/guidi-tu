import 'package:flutter/material.dart';

import '../flame/custom_board.dart';

class OuijaBoard extends CustomBoard<OuijaBoardCell> {
  @override
  Paint get paint => Paint()
    ..color = Colors.blueGrey.shade200
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  OuijaBoard({
    required super.rect,
    required super.gridColumns,
    required super.gridRows,
  });

  @override
  OuijaBoardCell createCell(int row, int column) =>
      OuijaBoardCell(this, row, column);
}

class OuijaBoardCell extends CustomBoardCell {
  OuijaBoardCell(super.board, super.row, super.column);
}
