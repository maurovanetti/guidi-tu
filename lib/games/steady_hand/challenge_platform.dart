import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class ChallengePlatform extends PositionComponent {
  Vector2 boardSize;
  final double breadth = 1 / 10;
  final double gap = 1 / 20;

  ChallengePlatform(this.boardSize)
      : super(
          position: Vector2.zero(),
          anchor: Anchor.topLeft,
          size: boardSize,
        ) {
    priority = 0;
  }

  final Paint paint = Paint()..color = Colors.grey;

  void _addCorridor(
    Vector2 relativePosition, // of top-left corner
    {
    double? relativeWidth,
    double? relativeHeight,
  }) {
    final relativeSize = Vector2(
      relativeWidth ?? breadth,
      relativeHeight ?? breadth,
    );
    Vector2 absolutePosition = relativePosition..multiply(boardSize);
    final rectangle = RectangleComponent.relative(
      relativeSize,
      parentSize: boardSize,
      position: absolutePosition,
      anchor: Anchor.topLeft,
      paint: paint,
    );
    // Adds 1 pixel to each side to avoid graphic artefacts at the edges
    rectangle.size += Vector2.all(1 / Forge2DGame.defaultZoom);
    // ignore: avoid-async-call-in-sync-function
    add(rectangle);
  }

  Rect _addSpiral(Rect rect) {
    // Rightward branch
    _addCorridor(
      Vector2(rect.left, rect.top),
      relativeWidth: rect.width,
    );
    if (rect.height < breadth) {
      return Rect.zero;
    }
    // Downward branch
    _addCorridor(
      Vector2(rect.right - breadth, rect.top + breadth),
      relativeHeight: rect.height - breadth,
    );
    // Leftward branch
    _addCorridor(
      Vector2(rect.left, rect.bottom - breadth),
      relativeWidth: rect.width - breadth,
    );
    // Upward branch
    _addCorridor(
      Vector2(rect.left, rect.top + breadth + gap),
      relativeHeight: rect.height - breadth - gap - breadth,
    );
    // Short rightward connector to the next spiral
    _addCorridor(
      Vector2(rect.left + breadth, rect.top + breadth + gap),
      relativeWidth: gap,
    );
    var delta = breadth + gap;
    return Rect.fromLTWH(
      rect.left + delta,
      rect.top + delta,
      rect.width - delta - delta,
      rect.height - delta - delta,
    );
  }

  @override
  void onLoad() {
    for (Rect rect = const Rect.fromLTWH(0, 0, 1, 1);
        rect.width > 0 && rect.height > 0;
        rect = _addSpiral(rect)) {
      debugPrint("New loop of the spiral");
    }
  }
}
