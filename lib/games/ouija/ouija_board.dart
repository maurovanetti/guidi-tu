import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../flame/custom_board.dart';
import 'ouija_item.dart';

class OuijaBoard extends CustomBoard<OuijaBoardCell> {
  final int slots;

  late final List<OuijaPassiveItem?> _passiveItems;
  final _activeItems = <String, OuijaActiveItem>{};

  final _wordNotifier = ValueNotifier('');

  ValueListenable<String> get wordNotifier => _wordNotifier;

  @override
  Paint get paint => Paint()
    ..color = Colors.blueGrey.shade200
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  double get slotWidth => size.x / slots;

  // ignore: match-getter-setter-field-names
  double get slotHeight => cellHeight;

  Vector2 get slotSize => Vector2(slotWidth, slotHeight);

  String get word => _wordNotifier.value;

  set word(String value) => _wordNotifier.value = value;

  OuijaBoard({
    required super.rect,
    required super.gridColumns,
    required super.gridRows,
    required this.slots,
  }) {
    _passiveItems = List.filled(slots, null);
  }

  @override
  OuijaBoardCell handleCreateCell(int row, int column) =>
      OuijaBoardCell(this, row, column);

  void registerSlotItem(int slot, OuijaPassiveItem ouijaPassiveItem) {
    assert(slot >= 0 && slot < slots);
    _passiveItems[slot] = ouijaPassiveItem;
  }

  void registerLetterItem(OuijaActiveItem ouijaActiveItem, String letter) {
    _activeItems[letter] = ouijaActiveItem;
  }

  bool tryAddLetter(String letter) {
    if (word.length >= slots) {
      return false;
    }
    word += letter;
    _activeItems[letter]?.isClickable = false;
    _refreshSlots();
    return true;
  }

  bool tryRemoveLetter() {
    if (word.isNotEmpty) {
      _activeItems[word.characters.last]?.isClickable = true;
      word = word.characters.getRange(0, word.length - 1).toString();
      _refreshSlots();
      return true;
    }
    return false;
  }

  Vector2? spotOf(String letter) => _activeItems[letter]?.center;

  void _refreshSlots() {
    for (int slot = 0; slot < slots; slot++) {
      _passiveItems[slot]?.letter = slot < word.length ? word[slot] : '';
    }
  }
}

// ignore: prefer-overriding-parent-equality
class OuijaBoardCell extends CustomBoardCell {
  @override
  final OuijaBoard board;

  const OuijaBoardCell(this.board, super.row, super.column);
}
