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
  static Vector2 get lightDirection => _lightDirection;
  static set lightDirection(Vector2 value) =>
      _lightDirection = value.normalized();

  // Using BasicPalette.black or .white here makes no difference, it's the
  // colorFilter that does the magic
  static final Paint shadowPaint = BasicPalette.black.withAlpha(50).paint()
    ..colorFilter = const ColorFilter.mode(Colors.black, BlendMode.srcATop);

  // Defining a default size for all sprites in a game can make sense for
  // tile-based games
  static Vector2 defaultSpriteSize = Vector2.all(128.0);

  final String assetPath;
  bool hasShadow;

  double _elevation = 0; // The actual default is 10.0, see constructor below
  double get elevation => _elevation;
  set elevation(value) {
    // The shadow position must remain the same, so we need to update the
    // position of the sprite in the opposite direction of the light
    position -= lightDirection * (value - elevation);
    _elevation = value;
    _shadowOffset = null; // Invalidates the cached value
  }

  Vector2? _cachedLightDirection;
  Vector2? _shadowOffset; // Works like a cache
  Vector2 get shadowOffset {
    if (_shadowOffset == null || _cachedLightDirection != lightDirection) {
      _cachedLightDirection = lightDirection;
      Vector2 v = _lightDirection.clone();
      // Compensate for the sprite's rotation
      v.rotate(-angle);
      _shadowOffset = v * elevation;
    }
    return _shadowOffset!;
  }

  @override
  set angle(double a) {
    _shadowOffset = null; // Invalidates the cached value
    super.angle = a;
  }

  Vector2 get groundLevelPosition => position + shadowOffset;

  CustomSpriteComponent(
    this.assetPath,
    Vector2 position, {
    this.hasShadow = true,
    double? elevation,
    Vector2? size,
    Anchor? anchor,
  }) : super(
          size: size ?? defaultSpriteSize,
          anchor: anchor ?? Anchor.center,
          position: position,
        ) {
    // If there's no shadow, the default elevation is 0 to prevent the sprite
    // from being rendered in a different initial position than expected
    this._elevation = elevation ?? (hasShadow ? 0.0 : 5.0);
  }

  @override
  void render(Canvas canvas) {
    // Reminder: this uses local coordinates!
    // Shadow sprite
    if (hasShadow) {
      sprite?.render(
        canvas,
        position: shadowOffset,
        size: size,
        overridePaint: shadowPaint,
      );
    }
    // Main sprite
    super.render(canvas);
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

  bool Function()? onSnap; // If false, the snap is forbidden
  void Function()? onFallbackSnap;
  bool Function()? onUnsnap; // If false, the snap is locked

  DraggableCustomSpriteComponent(String assetPath, Vector2 position,
      {bool hasShadow = true,
      double elevation = 10.0,
      Vector2? size,
      Anchor? anchor})
      : super(
          assetPath,
          position,
          hasShadow: hasShadow,
          elevation: elevation,
          size: size,
          anchor: anchor,
        );

  @override
  bool onDragStart(DragStartInfo info) {
    if (onUnsnap?.call() ?? true) {
      elevation +=
          extraElevationWhileDragged; // The position is updated in super
      _deltaPositionWhileDragged = info.eventPosition.game - position;
    } else {
      debugPrint('Dragging is forbidden because component is snap-locked');
    }
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

    bool regularSnapFound = false; // as opposed to fallback snap
    // Snaps to the closest spot
    if (snapRule != null) {
      final minSpotDistance = snapRule!.spots
          .map((spot) => spot - position)
          .reduce((a, b) => a.length < b.length ? a : b);
      if (minSpotDistance.length < snapRule!.maxSnapDistance) {
        position += minSpotDistance;
        regularSnapFound = (onSnap?.call() ?? true);
      }
      if (!regularSnapFound) {
        position = snapRule!.fallbackSpot;
        onFallbackSnap?.call();
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
