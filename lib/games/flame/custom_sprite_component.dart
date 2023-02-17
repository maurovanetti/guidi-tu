import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' hide Draggable;

class CustomSpriteComponent<T extends Game> extends SpriteComponent
    with HasGameReference<T> {
  // The light direction affects the shadow and is the same for all sprites
  static Vector2 _lightDirection = Vector2(-1.0, 2.0).normalized();
  static get lightDirection => _lightDirection;
  static set lightDirection(value) => _lightDirection = value.normalized();

  // Using BasicPalette.black or .white here makes no difference, it's the
  // colorFilter that does the magic
  static final Paint shadowPaint = BasicPalette.black.withAlpha(50).paint()
    ..colorFilter = const ColorFilter.mode(Colors.black, BlendMode.srcATop);

  final String assetPath;
  bool hasShadow;
  double _elevation = 0; // The actual default is 10.0, see constructor below
  double get elevation => _elevation;
  set elevation(value) {
    // The shadow position must remain the same, so we need to update the
    // position of the sprite in the opposite direction of the light
    position -= lightDirection * (value - elevation);
    _elevation = value;
  }

  get groundLevelPosition => position + lightDirection * elevation;

  CustomSpriteComponent(this.assetPath, Vector2 position,
      {this.hasShadow = true, double? elevation})
      : super(
          size: Vector2.all(128.0),
          anchor: Anchor.center,
          position: position,
        ) {
    // If there's no shadow, the default elevation is 0 to prevent the sprite
    // from being rendered in a different initial position than expected
    elevation ??= hasShadow ? 0.0 : 10.0;
    this.elevation = elevation;
  }

  @override
  void render(Canvas canvas) {
    // Shadow sprite
    if (hasShadow) {
      sprite?.render(
        canvas,
        position: lightDirection * elevation,
        size: size,
        overridePaint: shadowPaint,
      );
    }
    // Main sprite
    super.render(canvas);
    // Draw something on top of the sprite
  }

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite(assetPath);
  }
}

class DraggableCustomSpriteComponent<T extends Game>
    extends CustomSpriteComponent<T> with Draggable {
  final double extraElevationWhileDragged = 15.0;
  Vector2 _deltaPositionWhileDragged = Vector2.zero();
  late SnapRule? snapRule;

  DraggableCustomSpriteComponent(String assetPath, Vector2 position,
      {bool hasShadow = true, double elevation = 10.0})
      : super(assetPath, position, hasShadow: hasShadow, elevation: elevation);

  @override
  bool onDragStart(DragStartInfo info) {
    elevation += extraElevationWhileDragged; // The position is updated in super
    _deltaPositionWhileDragged = info.eventPosition.game - position;
    return false;
  }

  @override
  bool onDragUpdate(DragUpdateInfo info) {
    if (isDragged) {
      final localPosition = info.eventPosition.game;
      position = localPosition - _deltaPositionWhileDragged;
    }
    return false;
  }

  void _onDragStop() {
    // _deltaPositionWhileDragged becomes irrelevant
    elevation -= extraElevationWhileDragged; // The position is updated in super

    // Snaps to the closest spot
    if (snapRule != null) {
      final minSpotDistance = snapRule!.spots
          .map((spot) => spot - position)
          .reduce((a, b) => a.length < b.length ? a : b);
      if (minSpotDistance.length < snapRule!.maxSnapDistance) {
        position += minSpotDistance;
      } else {
        position = snapRule!.fallbackSpot;
      }
    }
  }

  @override
  bool onDragEnd(DragEndInfo info) {
    _onDragStop();
    return false;
  }

  @override
  bool onDragCancel() {
    _onDragStop();
    return false;
  }
}

class SnapRule {
  Iterable<Vector2> spots;
  double maxSnapDistance;
  late Vector2 fallbackSpot;

  SnapRule(
      {required this.spots,
      this.maxSnapDistance = double.infinity,
      Vector2? fallbackSpot}) {
    assert(spots.isNotEmpty || fallbackSpot != null,
        'At least one spot is required');
    this.fallbackSpot = fallbackSpot ?? spots.first;
  }
}
