import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/rendering.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';

class CustomSpriteComponent<T extends FlameGame>
    extends SpriteAnimationComponent with HasGameReference<T> {
  // Using BasicPalette.black or .white here makes no difference, it's the
  // colorFilter that does the magic.
  static final shadowPaint = BasicPalette.black.withAlpha(50).paint()
    ..colorFilter = const ColorFilter.mode(Colors.black, BlendMode.srcATop);

  // Defining a default size for all sprites in a game can make sense for
  // tile-based games.
  static final defaultSpriteSize = Vector2.all(128.0);

  // The assetPath can be a path to a single image or a path to a directory that
  // contains multiple frames of an animation. If the path ends with ".png" or
  // ".jpg" or ".jpeg", it's assumed to be a single image.
  final String assetPath;
  final bool keepAspectRatio;
  int? fps;
  bool hasShadow;
  bool visible = true;

  // Optional stamp sprite that is rendered on top of the main sprite.
  final String? stampAssetPath;
  static const stampSizeFactor = 0.33;
  Sprite? _stampSprite;

  // The light direction affects the shadow and is the same for all sprites.
  static Vector2 _lightDirection = Vector2(-1.0, 2.0).normalized();
  double _elevation = 0; // The actual default is 10.0, see constructor below
  Vector2? _cachedLightDirection;
  Vector2? _shadowOffset; // Works like a cache

  final _tintDecorator = Decorator(); // default no-op

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

  static Vector2 get lightDirection => _lightDirection;

  double get elevation => _elevation;

  Vector2 get groundLevelPosition => position + shadowOffset;

  static set lightDirection(Vector2 value) =>
      _lightDirection = value.normalized();

  set elevation(double value) {
    // The shadow position must remain the same, so we need to update the
    // position of the sprite in the opposite direction of the light.
    position -= lightDirection * (value - elevation);
    _elevation = value;
    _shadowOffset = null; // Invalidates the cached value
  }

  @override
  set angle(double value) {
    // ignore: match-getter-setter-field-names
    _shadowOffset = null; // Invalidates the cached value
    super.angle = value;
  }

  CustomSpriteComponent(
    this.assetPath,
    Vector2 position, {
    this.hasShadow = true,
    this.stampAssetPath,
    double? elevation,
    Vector2? size,
    this.keepAspectRatio = false,
    Anchor? anchor,
    super.priority,
    this.fps,
    Color? color,
  }) : super(
          size: size ?? defaultSpriteSize,
          anchor: anchor ?? Anchor.center,
          position: position,
        ) {
    // If there's no shadow, the default elevation is 0 to prevent the sprite
    // from being rendered in a different initial position than expected.
    _elevation = elevation ?? (hasShadow ? 1.0 : 0.0);
    if (color != null) {
      _tintDecorator.addLast(PaintDecorator.tint(color));
    }
  }

  @override
  void render(Canvas canvas) {
    if (!visible) return;
    // Reminder: this uses local coordinates!
    // Shadow sprite
    if (hasShadow && opacity == 1.0) {
      animationTicker?.getSprite().render(
            canvas,
            position: shadowOffset.clone()..rotate(-absoluteAngle),
            size: size,
            overridePaint: shadowPaint,
          );
    }

    // Main sprite
    // The tint decorator should not be applied to the shadow
    _tintDecorator.applyChain(
      (Canvas c) => super.render(c),
      canvas,
    );

    // Stamp sprite
    if (_stampSprite != null) {
      Paint stampPaint = Paint()..color = Colors.white.withOpacity(opacity);
      var stampSize = size * stampSizeFactor;
      _stampSprite!.render(
        canvas,
        size: stampSize,
        position: (size - stampSize) / 2,
        overridePaint: stampPaint,
      );
    }
  }

  @override
  Future<void> onLoad() async {
    Vector2 referenceSize;
    if (assetPath.endsWith('.png') ||
        assetPath.endsWith('.jpg') ||
        assetPath.endsWith('.jpeg')) {
      var sprite = await game.loadSprite(assetPath);
      referenceSize = sprite.srcSize;
      animation =
          SpriteAnimation.spriteList([sprite], stepTime: double.infinity);
    } else {
      try {
        animation = await AnimationLoader.make(assetPath, fps: fps);
        referenceSize = animation!.frames.first.sprite.srcSize;
      } catch (error) {
        debugPrint('Error loading animation: $error');
        return;
      }
    }
    if (keepAspectRatio) {
      double wrongAspectRatio = size.x / size.y;
      double originalAspectRatio = referenceSize.x / referenceSize.y;
      if (wrongAspectRatio > originalAspectRatio) {
        // too wide
        size.x = size.y * originalAspectRatio;
      } else if (wrongAspectRatio < originalAspectRatio) {
        // too tall
        size.y = size.x / originalAspectRatio;
      }
    }
    if (stampAssetPath != null) {
      _stampSprite = await game.loadSprite(stampAssetPath!);
    }
  }

  Future<void> flash() async {
    for (var i = 0; i < 7; i++) {
      visible = !visible;
      await Delay.waitFor(1 / 5);
    }
    visible = false;
  }
}

class DraggableCustomSpriteComponent<T extends FlameGame>
    extends CustomSpriteComponent<T> with DragCallbacks {
  bool draggable;

  static const defaultExtraElevationWhileDragged = 15.0;
  final double extraElevationWhileDragged;
  SnapRule? snapRule;

  BoolCallback? onSnap; // If false, the snap is forbidden
  VoidCallback? onFallbackSnap;
  BoolCallback? onUnsnap; // If false, the snap is locked

  DraggableCustomSpriteComponent(
    super.assetPath,
    super.position, {
    super.stampAssetPath,
    super.hasShadow = true,
    super.elevation = 10.0,
    super.size,
    super.anchor,
    super.fps,
    super.color,
    this.draggable = true,
    this.extraElevationWhileDragged = defaultExtraElevationWhileDragged,
  });

  @override
  void onDragStart(DragStartEvent event) {
    debugPrint("onDragStart");
    if (draggable) {
      super.onDragStart(event);
      if (onUnsnap?.call() ?? true) {
        elevation +=
            extraElevationWhileDragged; // The position is updated in super
        priority =
            elevation.toInt(); // Makes sure the component is rendered on top
      } else {
        debugPrint('Dragging is forbidden because component is snap-locked');
      }
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (draggable) {
      position += event.localDelta;
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (draggable) {
      super.onDragEnd(event);
      _onDragStop();
    }
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    if (draggable) {
      super.onDragCancel(event);
      _onDragStop();
    }
  }

  void _onDragStop() {
    // _deltaPositionWhileDragged becomes irrelevant
    elevation -= extraElevationWhileDragged; // The position is updated in super
    priority = elevation.toInt(); // Restores the original priority

    // Snaps to the closest spot
    if (snapRule != null) {
      bool wasRegularSnapFound = false; // as opposed to fallback snap
      final minSpotDistance = snapRule!.spots
          .map((spot) => spot - position)
          .reduce((a, b) => a.length < b.length ? a : b);
      if (minSpotDistance.length < snapRule!.maxSnapDistance) {
        position += minSpotDistance;
        wasRegularSnapFound = (onSnap?.call() ?? true);
      }
      if (!wasRegularSnapFound) {
        position = snapRule!.fallbackSpot;
        onFallbackSnap?.call();
      }
    }
  }
}

class SnapRule {
  Iterable<Vector2> spots;
  double maxSnapDistance;
  late Vector2 fallbackSpot;

  SnapRule({
    required this.spots,
    this.maxSnapDistance = double.infinity,
    Vector2? fallbackSpot,
  }) {
    assert(spots.isNotEmpty || fallbackSpot != null,
        'At least one spot is required');
    this.fallbackSpot = fallbackSpot ?? spots.first;
  }
}
