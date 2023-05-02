import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '/games/flame/custom_sprite_component.dart';

class SteadyHandBall extends BodyComponent {
  static const radius = 3.0;

  final Vector2 position;
  final void Function() notifyFallen;

  StreamSubscription<AccelerometerEvent>? _accelerations;

  SteadyHandBall(this.position, {required this.notifyFallen})
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
    add(SteadyHandBallSprite());
    _accelerations = accelerometerEvents.listen((AccelerometerEvent event) {
      body.applyForce(Vector2(-event.x, event.y) * 20);
    });
    return super.onLoad();
  }

  @override
  void onRemove() {
    _accelerations?.cancel();
    super.onRemove();
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
