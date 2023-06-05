import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:guidi_tu/games/rps.dart';

import '/common/common.dart';
import '../flame/priorities.dart';
import 'rps_board.dart';

class RockPaperScissorsItemTextRenderer extends TextPaint {
  RockPaperScissorsItemTextRenderer({double? height, required Color color})
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

class RockPaperScissorsItem extends TextComponent {
  RockPaperScissorsItem._internal(
    String representation,
    Vector2 position, {
    required Vector2 boxSize,
    required Color color,
  }) : super(
          text: representation,
          textRenderer: RockPaperScissorsItemTextRenderer(
            height: boxSize.x,
            color: color,
          ),
          position: position,
          anchor: const Anchor(0.5, 0.45), // to compensate baseline offset
          priority: Priorities.stickerPriority,
        ) {
    assert(text.length == 1);
  }

  RockPaperScissorsItem._onCell(
    String representation,
    RockPaperScissorsBoardCell cell,
    Color color,
  ) : this._internal(
          representation,
          cell.center,
          boxSize: cell.board.cellSize,
          color: color,
        );

  RockPaperScissorsItem._onSlot(
    String representation,
    RockPaperScissorsBoard board,
    int slot,
    Color color,
  ) : this._internal(
          representation,
          board.absolutePositionOfAnchor(Anchor.bottomLeft) +
              board.slotSize / 2 +
              Vector2(slot.toDouble(), 0) * board.slotWidth,
          boxSize: board.slotSize,
          color: color,
        );
}

class RockPaperScissorsActiveItem extends RockPaperScissorsItem
    with TapCallbacks {
  // ignore: avoid-non-ascii-symbols
  static const backspaceEmoji = '⌫';

  late final VoidCallback onSelect;

  RockPaperScissorsActiveItem(
    RockPaperScissorsGesture gesture,
    RockPaperScissorsBoardCell cell,
  ) : super._onCell(gesture.hand, cell, Colors.white) {
    onSelect = () {
      if (!cell.board.addGesture(gesture)) {
        debugPrint('No more slots to fill');
      }
    };
  }

  RockPaperScissorsActiveItem.backspace(
    RockPaperScissorsBoardCell cell,
  ) : super._onCell(backspaceEmoji, cell, Colors.grey) {
    onSelect = () {
      if (!cell.board.removeGesture()) {
        debugPrint('No letters to remove');
      }
    };
  }

  @override
  void onTapDown(TapDownEvent event) => onSelect();
}

class RockPaperScissorsPassiveItem extends RockPaperScissorsItem {
  static const String pending = '_';

  String get representation => text;
  set representation(String letter) {
    text = letter.isEmpty ? pending : letter.characters.first;
  }

  RockPaperScissorsPassiveItem(RockPaperScissorsBoard board, int slot)
      : super._onSlot(pending, board, slot, Colors.yellow[200]!) {
    board.registerSlotItem(slot, this);
  }
}
