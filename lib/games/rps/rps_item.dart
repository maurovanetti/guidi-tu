import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/games/flame/custom_sprite_component.dart';
import '/games/flame/priorities.dart';
import '/games/rps.dart';
import 'rps_board.dart';

class RockPaperScissorsTextRenderer extends TextPaint {
  RockPaperScissorsTextRenderer({double? height, required Color color})
      : super(
          style: TextStyle(
            color: color,
            fontFamily: StyleGuide.fontFamily,
            fontSize: _fontSizeFor(height) ?? StyleGuide.inGameFontSize,
            height: 1.0,
          ),
        );

  static double? _fontSizeFor(double? height) {
    return height == null ? null : height * (7 / 10);
  }
}

class RockPaperScissorsIcon extends CustomSpriteComponent {
  RockPaperScissorsIcon(
    RockPaperScissorsGesture gesture,
    Vector2 position, {
    required super.size,
    Color? color,
  }) : super(
          color == null ? gesture.assetPaths.color : gesture.assetPaths.grey,
          position,
          keepAspectRatio: true,
          priority: Priorities.stickerPriority,
          color: color,
        );
}

class RockPaperScissorsText extends TextComponent {
  RockPaperScissorsText(
    String representation,
    Vector2? position, {
    required Vector2 boxSize,
    required Color color,
  }) : super(
          text: representation,
          textRenderer: RockPaperScissorsTextRenderer(
            height: boxSize.x,
            color: color,
          ),
          position: position,
          anchor: const Anchor(0.5, 0.3), // to compensate baseline offset
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
    anchor = Anchor.center;
  }

  void setGesture(RockPaperScissorsGesture gesture, {Color? color}) {
    _clear();
    var iconSize = size.clone();
    iconSize.x *= 4 / 5;
    // ignore: avoid-async-call-in-sync-function
    add(RockPaperScissorsIcon(
      gesture,
      size / 2,
      size: iconSize,
      color: color,
    ));
  }

  void setText(String text, {required Color color}) {
    _clear();
    // ignore: avoid-async-call-in-sync-function
    add(RockPaperScissorsText(
      text,
      size / 2,
      boxSize: size,
      color: color,
    ));
  }

  void _clear() {
    removeWhere(
      (c) => c is RockPaperScissorsText || c is RockPaperScissorsIcon,
    );
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
    setGesture(gesture);
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
  static final color = Colors.yellow[200]!;
  static const pending = '_';

  RockPaperScissorsGesture? _gesture;
  RockPaperScissorsGesture? get gesture => _gesture;
  set gesture(RockPaperScissorsGesture? value) {
    _gesture = value;
    if (value == null) {
      setText(pending, color: color);
    } else {
      setGesture(value);
    }
  }

  RockPaperScissorsPassiveItem(RockPaperScissorsBoard board, int slot)
      : super(
          board.absolutePositionOfAnchor(Anchor.bottomLeft) +
              board.slotSize / 2 +
              Vector2(slot.toDouble(), 0) * board.slotWidth,
          size: board.slotSize,
        ) {
    setText(pending, color: color);
    board.registerSlotItem(slot, this);
  }
}
