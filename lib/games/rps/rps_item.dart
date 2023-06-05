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

class TextRockPaperScissorsItem extends TextComponent {
  TextRockPaperScissorsItem(
    String representation,
    Vector2? position, {
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
}

class RockPaperScissorsItem extends PositionComponent {
  RockPaperScissorsItem(
    Vector2 position, {
    required Vector2 size,
  }) {
    this.position = position;
    this.size = size;
  }

  void setGesture(RockPaperScissorsGesture gesture, {required Color color}) {
    removeWhere((c) => c is TextRockPaperScissorsItem);
    add(TextRockPaperScissorsItem(
      gesture.hand,
      null,
      boxSize: size,
      color: color,
    ));
  }

  void setText(String text, {required Color color}) {
    removeWhere((c) => c is TextRockPaperScissorsItem);
    add(TextRockPaperScissorsItem(
      text,
      null,
      boxSize: size,
      color: color,
    ));
  }
}

class RockPaperScissorsActiveItem extends RockPaperScissorsItem
    with TapCallbacks {
  // ignore: avoid-non-ascii-symbols
  static const backspaceEmoji = '⌫';

  late final VoidCallback onSelect;

  RockPaperScissorsActiveItem(
    RockPaperScissorsGesture gesture,
    RockPaperScissorsBoardCell cell,
  ) : super(cell.center, size: cell.board.cellSize) {
    setGesture(gesture, color: Colors.white);
    onSelect = () {
      if (!cell.board.addGesture(gesture)) {
        debugPrint('No more slots to fill');
      }
    };
  }

  RockPaperScissorsActiveItem.backspace(
    RockPaperScissorsBoardCell cell,
  ) : super(cell.center, size: cell.board.cellSize) {
    setText(backspaceEmoji, color: Colors.grey);
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

  String _text = '';

  String get representation => _text;
  set representation(String letter) {
    _text = letter.isEmpty ? pending : letter.characters.first;
    setText(_text, color: Colors.yellow[200]!);
  }

  RockPaperScissorsPassiveItem(RockPaperScissorsBoard board, int slot)
      : super(
          board.absolutePositionOfAnchor(Anchor.bottomLeft) +
              board.slotSize / 2 +
              Vector2(slot.toDouble(), 0) * board.slotWidth,
          size: board.slotSize,
        ) {
    setText(pending, color: Colors.yellow[200]!);
    board.registerSlotItem(slot, this);
  }
}
