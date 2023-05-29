import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:guidi_tu/games/ouija/ouija_board.dart';

import '/common/common.dart';
import '../flame/priorities.dart';

class OuijaItem extends TextComponent {
  OuijaItem(String letter, Vector2 position, {double? height})
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

  OuijaItem.onCell(String letter, OuijaBoardCell cell)
      : this(letter, cell.center, height: cell.board.cellHeight);

  OuijaItem.onSlot(String letter, OuijaBoard board, int slot)
      : this(
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
