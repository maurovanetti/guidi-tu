import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../flame/custom_board.dart';
import 'ouija_item.dart';

class OuijaBoard extends CustomBoard<OuijaBoardCell> {
  String word = '';
  final int slots;

  late final List<OuijaPassiveItem?> _slotItems;

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
  }) {
    _slotItems = List.filled(slots, null);
  }

  @override
  OuijaBoardCell createCell(int row, int column) =>
      OuijaBoardCell(this, row, column);

  void registerSlotItem(int slot, OuijaPassiveItem ouijaPassiveItem) {
    assert(slot >= 0 && slot < slots);
    _slotItems[slot] = ouijaPassiveItem;
  }

  bool addLetter(String letter) {
    if (word.length >= slots) {
      return false;
    }
    word += letter;
    _refreshSlots();
    return true;
  }

  bool removeLetter() {
    if (word.isNotEmpty) {
      word = word.characters.getRange(0, word.length - 1).toString();
      _refreshSlots();
      return true;
    }
    return false;
  }

  void _refreshSlots() {
    for (int slot = 0; slot < slots; slot++) {
      _slotItems[slot]?.letter = slot < word.length ? word[slot] : '';
    }
  }
}

class OuijaBoardCell extends CustomBoardCell {
  @override
  final OuijaBoard board;

  OuijaBoardCell(this.board, super.row, super.column);
}
