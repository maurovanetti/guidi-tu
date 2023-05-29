import 'package:flame/components.dart';
import 'package:flame/events.dart';
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
  late Vector2 _boxSize;

  OuijaItem._internal(
    String letter,
    Vector2 position, {
    required Vector2 boxSize,
    required Color color,
  }) : super(
          text: letter,
          textRenderer: OuijaItemTextRenderer(height: boxSize.x, color: color),
          position: position,
          anchor: const Anchor(0.5, 0.45), // to compensate baseline offset
          priority: Priorities.stickerPriority,
        ) {
    assert(text.length == 1);
    _boxSize = boxSize;
  }

  OuijaItem._onCell(String letter, OuijaBoardCell cell, Color color)
      : this._internal(
          letter,
          cell.center,
          boxSize: cell.board.cellSize,
          color: color,
        );

  OuijaItem._onSlot(String letter, OuijaBoard board, int slot, Color color)
      : this._internal(
          letter,
          board.absolutePositionOfAnchor(Anchor.bottomLeft) +
              board.slotSize / 2 +
              Vector2(slot.toDouble(), 0) * board.slotWidth,
          boxSize: board.slotSize,
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
      height: _boxSize.x,
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
      canBeClicked ? Colors.white : Colors.black;

  static Color backgroundColor(bool canBeClicked) => color(!canBeClicked);

  @override
  void render(Canvas canvas) {
    const borderRadius = BorderRadius.all(Radius.circular(3.0));
    var boxWidth = _boxSize.x * (17 / 20);
    var boxHeight = _boxSize.y * (17 / 20);
    var left = width / 2 - boxWidth / 2;
    var top = height / 2 - boxHeight / 2;
    RRect rect = borderRadius.toRRect(Rect.fromLTWH(
      left,
      top,
      boxWidth,
      boxHeight,
    ));
    canvas.drawRRect(rect, Paint()..color = backgroundColor(clickable));
    super.render(canvas);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (clickable) onSelect();
  }
}

class OuijaPassiveItem extends OuijaItem {
  static const String pending = '_';

  String get letter => text;
  set letter(String letter) {
    text = letter.isEmpty ? pending : letter.characters.first;
  }

  OuijaPassiveItem(OuijaBoard board, int slot)
      : super._onSlot(pending, board, slot, Colors.yellow[200]!) {
    board.registerSlotItem(slot, this);
  }
}
