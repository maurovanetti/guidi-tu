import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/forge2d_game.dart';

abstract class Forge2DGameWithDragging extends Forge2DGame with DragCallbacks {
  PositionComponent get dragged;

  // Only one pointer is valid
  num _dragPointerId = double.nan;

  @override
  void onDragStart(DragStartEvent event) {
    // The first pointer used is the only one that is valid, until it's released
    if (_dragPointerId.isNaN) {
      _dragPointerId = event.pointerId;
    }
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (event.pointerId == _dragPointerId && !event.localPosition.isNaN) {
      dragged.position = screenToWorld(event.localPosition);
    }
    super.onDragUpdate(event);
  }

  @override
  bool containsLocalPoint(Vector2 p) =>
      // This fixes the mismatch between Forge2D and ordinary coordinate systems
      super.containsLocalPoint(screenToWorld(p));

  @override
  void onDragCancel(DragCancelEvent event) {
    if (event.pointerId == _dragPointerId) {
      _dragPointerId = double.nan;
    }
    super.onDragCancel(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (event.pointerId == _dragPointerId) {
      _dragPointerId = double.nan;
    }
    super.onDragEnd(event);
  }
}
