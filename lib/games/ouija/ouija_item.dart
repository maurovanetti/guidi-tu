import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '../flame/priorities.dart';
import 'ouija_board.dart';

class OuijaItem extends TextComponent {
  OuijaItem._internal(String letter, Vector2 position, {double? height})
      : super(
          text: letter,
          textRenderer: TextPaint(
            style: TextStyle(
              color: Colors.lightBlueAccent,
              fontFamily: StyleGuide.fontFamily,
              fontSize: _fontSizeFor(height) ?? StyleGuide.inGameFontSize,
              height: 1.0,
            ),
          ),
          position: position,
          anchor: const Anchor(0.5, 0.45), // to compensate baseline offset
          priority: Priorities.messagePriority,
        ) {
    assert(text.length == 1);
  }

  OuijaItem._onCell(String letter, OuijaBoardCell cell)
      : this._internal(letter, cell.center, height: cell.board.cellHeight);

  OuijaItem._onSlot(String letter, OuijaBoard board, int slot)
      : this._internal(
          letter,
          board.absolutePositionOfAnchor(Anchor.bottomLeft) +
              board.slotSize / 2 +
              Vector2(slot.toDouble(), 0) * board.slotWidth,
          height: board.slotHeight,
        );

  static double? _fontSizeFor(double? height) {
    if (height == null) {
      return null;
    }
    return height * (7 / 10);
  }
}

class OuijaActiveItem extends OuijaItem with TapCallbacks {
  // ignore: avoid-non-ascii-symbols
  static const backspace = '⌫';

  late final VoidCallback onSelect;

  OuijaActiveItem(String letter, OuijaBoardCell cell)
      : super._onCell(letter, cell) {
    onSelect = letter == backspace
        ? () {
            if (!cell.board.removeLetter()) {
              debugPrint('No letters to remove');
            }
          }
        : () {
            if (!cell.board.addLetter(letter)) {
              debugPrint('No more slots to fill');
            }
          };
  }

  @override
  void onTapUp(TapUpEvent event) => onSelect();
}

class OuijaPassiveItem extends OuijaItem {
  static const String pending = '?';

  String get letter => text;
  set letter(String letter) {
    text = letter.isEmpty ? pending : letter.characters.first;
  }

  OuijaPassiveItem(OuijaBoard board, int slot)
      : super._onSlot(pending, board, slot) {
    board.registerSlotItem(slot, this);
  }
}
