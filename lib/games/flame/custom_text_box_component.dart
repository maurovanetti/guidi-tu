import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import 'priorities.dart';

class CustomTextBoxComponent extends TextBoxComponent {
  static const dismissDelay = 4;

  final _backgroundPaint = Paint()..color = Colors.white;

  static final _boxConfig = TextBoxConfig(
    margins: StyleGuide.widePadding,
  );

  CustomTextBoxComponent(
    String text,
    Vector2 position, {
    bool autoDismiss = true,
    double scale = 1,
  }) : super(
          text: text,
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.black,
              fontFamily: StyleGuide.fontFamily,
              fontSize: StyleGuide.inGameFontSize,
            ),
          ),
          boxConfig: _boxConfig,
          align: Anchor.center,
          anchor: Anchor.topCenter,
          position: position,
          priority: Priorities.messagePriority,
          scale: scale == 1 ? null : Vector2.all(scale),
        ) {
    if (autoDismiss) {
      Delay.after(dismissDelay, dismiss);
    }
  }

  @override
  void render(Canvas canvas) {
    RRect rect = StyleGuide.borderRadius.toRRect(
      Rect.fromLTRB(0, 0, width, height),
    );
    canvas.drawRRect(rect, _backgroundPaint);
    super.render(canvas);
  }

  void dismiss() {
    if (isMounted) {
      removeFromParent();
    }
  }
}
