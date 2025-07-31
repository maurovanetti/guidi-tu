import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:guidi_tu/common/common.dart';

import 'challenge_goal.dart';
import 'steady_hand_ball.dart';

class ChallengePlatform extends PositionComponent with HasGameReference {
  Vector2 boardSize;
  OnScore onScore;
  final breadth = 1 / 10;
  final gap = 1 / 20;
  final paint = Paint()..color = Colors.grey.withBlue(200);

  int _score = 0;

  ChallengePlatform(this.boardSize, this.onScore)
      : super(
          position: Vector2.zero(),
          anchor: Anchor.topLeft,
          size: boardSize,
        );

  @override
  void onLoad() {
    for (Rect rect = const Rect.fromLTWH(0, 0, 1, 1);
        rect.width > 0 && rect.height > 0;
        rect = _addSpiral(rect)) {
      debugPrint("New loop of the spiral");
    }
  }

  @override
  bool containsPoint(Vector2 point) {
    for (Component component in children.whereType<RectangleComponent>()) {
      if (component.containsPoint(point)) {
        return true;
      }
    }
    return false;
  }

  RectangleComponent _addCorridor(
    Vector2 relativePosition, {
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
    rectangle.size += Vector2.all(1 / game.camera.viewfinder.zoom);
    // ignore: avoid-async-call-in-sync-function
    add(rectangle);
    return rectangle;
  }

  void _addGoal(Vector2 absolutePosition, Anchor anchor) {
    final goal = ChallengeGoal(
      absolutePosition,
      anchor: anchor,
      size: Vector2.all(breadth)..multiply(boardSize),
    );
    goal.onBeginContact = _onHitGoal;
    // ignore: avoid-async-call-in-sync-function
    add(goal);
    debugPrint("Added goal at $absolutePosition");
  }

  Rect _addSpiral(Rect rect) {
    // Rightward branch
    var corridor = _addCorridor(
      Vector2(rect.left, rect.top),
      relativeWidth: rect.width,
    );
    _addGoal(corridor.topLeftPosition + corridor.size, Anchor.bottomRight);
    if (rect.height < breadth) {
      return Rect.zero;
    }
    // Downward branch
    corridor = _addCorridor(
      Vector2(rect.right - breadth, rect.top + breadth),
      relativeHeight: rect.height - breadth,
    );
    _addGoal(corridor.topLeftPosition + corridor.size, Anchor.bottomRight);
    // Leftward branch
    corridor = _addCorridor(
      Vector2(rect.left, rect.bottom - breadth),
      relativeWidth: rect.width - breadth,
    );
    _addGoal(corridor.topLeftPosition, Anchor.topLeft);
    // Upward branch
    corridor = _addCorridor(
      Vector2(rect.left, rect.top + breadth + gap),
      relativeHeight: rect.height - breadth - gap - breadth,
    );
    _addGoal(corridor.topLeftPosition, Anchor.topLeft);
    // Short rightward connector to the next spiral
    var _ = _addCorridor(
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

  void _onHitGoal(Object other, Contact _) {
    if (other is SteadyHandBall) {
      _score++;
      onScore(_score);
    }
  }
}
