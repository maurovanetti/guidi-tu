import 'dart:async';
import 'dart:io';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '/games/flame/custom_sprite_component.dart';

class SteadyHandBall extends BodyComponent with KeyboardHandler {
  static const finalGravityMultiplier = 200.0;
  static const gravityMultiplierIncreasePerSecond = 40.0;

  final Vector2 position;
  final Component platform;
  final double radius;
  final void Function() notifyFallen;
  late final SteadyHandBallSprite sprite;

  double _gravityMultiplier = 0;
  bool _isFalling = false;

  StreamSubscription<AccelerometerEvent>? _accelerations;

  SteadyHandBall(
    this.position,
    this.platform, {
    required this.radius,
    required this.notifyFallen,
  }) : super(renderBody: false) {
    sprite = SteadyHandBallSprite(radius: radius);
  }

  void applyForce(Vector2 force) {
    if (!_isFalling) {
      body.applyForce(force * _gravityMultiplier);
    }
  }

  void applyImpulse(Vector2 impulse) {
    if (!_isFalling) {
      body.applyLinearImpulse(impulse * _gravityMultiplier);
    }
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;
    final fixtureDef = FixtureDef(shape)
      ..density = 0.5
      ..friction = 0.5;
    final bodyDef = BodyDef(
      userData: this,
      linearDamping: 0.5,
      angularDamping: 0.5,
      position: position,
      type: BodyType.dynamic,
    );
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  bool get isMobile => Platform.isAndroid || Platform.isIOS;

  @override
  Future<void> onLoad() {
    add(sprite);
    if (isMobile) {
      _accelerations = accelerometerEvents.listen((AccelerometerEvent event) {
        applyForce(Vector2(-event.x, event.y));
      });
    } else {
      debugPrint("This is not a mobile device. "
          "The accelerometer will be emulated by arrow keys.");
    }
    return super.onLoad();
  }

  @override
  void onRemove() {
    // ignore: avoid-async-call-in-sync-function
    _accelerations?.cancel();
    super.onRemove();
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    debugPrint("onKeyEvent: $event");
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      applyImpulse(Vector2(-1, 0));
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      applyImpulse(Vector2(1, 0));
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      applyImpulse(Vector2(0, -1));
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      applyImpulse(Vector2(0, 1));
    }
    return true;
  }

  @override
  void update(double dt) {
    var delta = gravityMultiplierIncreasePerSecond * dt;
    _gravityMultiplier =
        (_gravityMultiplier + delta).clamp(0, finalGravityMultiplier);
    if (!_isFalling & !platform.containsPoint(body.position)) {
      _isFalling = true;
      body.linearVelocity.setZero();
      body.setAwake(false);
      unawaited(sprite.flash());
      notifyFallen();
    }
    super.update(dt);
  }
}

class SteadyHandBallSprite extends CustomSpriteComponent {
  SteadyHandBallSprite({required double radius})
      : super(
          'steady_hand/ball.png',
          Vector2.zero(),
          anchor: Anchor.center,
          size: Vector2.all(radius * 2),
          hasShadow: true,
          elevation: radius / 3,
        ) {
    priority = 1;
  }
}
