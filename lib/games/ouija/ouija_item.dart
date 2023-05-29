import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '../flame/priorities.dart';
import 'ouija_board.dart';

class OuijaItemTextRenderer extends TextPaint {
  OuijaItemTextRenderer({double? height, required Color color})
      : super(
          style: TextStyle(
            color: color,
            fontFamily: StyleGuide.fontFamily,
            fontSize: _fontSizeFor(height) ?? StyleGuide.inGameFontSize,
            height: 1.0,
          ),
        );

  static double? _fontSizeFor(double? height) {
    if (height == null) {
      return null;
    }
    return height * (7 / 10);
  }
}

class OuijaItem extends TextComponent {
  late double? _cellHeight;

  OuijaItem._internal(
    String letter,
    Vector2 position, {
    double? height,
    required Color color,
  }) : super(
          text: letter,
          textRenderer: OuijaItemTextRenderer(height: height, color: color),
          position: position,
          anchor: const Anchor(0.5, 0.45), // to compensate baseline offset
          priority: Priorities.stickerPriority,
        ) {
    assert(text.length == 1);
    _cellHeight = height;
  }

  OuijaItem._onCell(String letter, OuijaBoardCell cell, Color color)
      : this._internal(
          letter,
          cell.center,
          height: cell.board.cellHeight,
          color: color,
        );

  OuijaItem._onSlot(String letter, OuijaBoard board, int slot, Color color)
      : this._internal(
          letter,
          board.absolutePositionOfAnchor(Anchor.bottomLeft) +
              board.slotSize / 2 +
              Vector2(slot.toDouble(), 0) * board.slotWidth,
          height: board.slotHeight,
          color: color,
        );
}

class OuijaActiveItem extends OuijaItem with TapCallbacks {
  // ignore: avoid-non-ascii-symbols
  static const backspace = '⌫';
  late final VoidCallback onSelect;

  bool _clickable = true;
  bool get clickable => _clickable;
  set clickable(bool value) {
    _clickable = value;
    textRenderer = OuijaItemTextRenderer(
      height: _cellHeight,
      color: color(clickable),
    );
  }

  OuijaActiveItem(String letter, OuijaBoardCell cell)
      : super._onCell(letter, cell, color(true)) {
    cell.board.registerLetterItem(this, letter);
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

  static Color color(bool canBeClicked) =>
      canBeClicked ? Colors.lightBlueAccent : Colors.grey;

  @override
  void onTapDown(TapDownEvent event) {
    if (clickable) onSelect();
  }
}

class OuijaPassiveItem extends OuijaItem {
  static const String pending = '?';

  String get letter => text;
  set letter(String letter) {
    text = letter.isEmpty ? pending : letter.characters.first;
  }

  OuijaPassiveItem(OuijaBoard board, int slot)
      : super._onSlot(pending, board, slot, Colors.green.shade300) {
    board.registerSlotItem(slot, this);
  }
}
