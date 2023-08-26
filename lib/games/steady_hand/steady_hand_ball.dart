import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '/games/flame/custom_sprite_component.dart';
import 'steady_hand_platform.dart';

class SteadyHandBall extends BodyComponent {
  static const radius = 3.0;
  static const finalGravityMultiplier = 200.0;
  static const gravityMultiplierIncreasePerSecond = 40.0;

  final Vector2 position;
  final SteadyHandPlatform platform;
  final void Function() notifyFallen;
  final sprite = SteadyHandBallSprite();

  double _gravityMultiplier = 0;
  bool _isFalling = false;

  StreamSubscription<AccelerometerEvent>? _accelerations;

  SteadyHandBall(this.position, this.platform, {required this.notifyFallen})
      : super(renderBody: false);

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

  @override
  Future<void> onLoad() {
    add(sprite);
    _accelerations = accelerometerEvents.listen((AccelerometerEvent event) {
      if (!_isFalling) {
        body.applyForce(Vector2(-event.x, event.y) * _gravityMultiplier);
      }
    });
    return super.onLoad();
  }

  @override
  void onRemove() {
    // ignore: avoid-async-call-in-sync-function
    _accelerations?.cancel();
    super.onRemove();
  }

  @override
  void update(double dt) {
    var delta = gravityMultiplierIncreasePerSecond * dt;
    _gravityMultiplier =
        (_gravityMultiplier + delta).clamp(0, finalGravityMultiplier);
    if (!_isFalling & !platform.isUnder(body)) {
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
  SteadyHandBallSprite()
      : super(
          'steady_hand/ball.png',
          Vector2.zero(),
          anchor: Anchor.center,
          size: Vector2.all(SteadyHandBall.radius * 2),
          hasShadow: true,
        ) {
    priority = 1;
  }
}
