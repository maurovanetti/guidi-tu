import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/games/flame/custom_sprite_component.dart';

class BoulesJack extends BoulesBowl {
  static const radius = 1.0;

  @override
  double get r => radius;

  BoulesJack(Vector2 position) : super(position, player: Player.none) {
    // The jack should not be shadowing the larger bowls
    priority--;
  }
}

class BoulesBowl extends BodyComponent with CustomNotifier {
  static const radius = 2.0;
  static const launchImpulseFactor = 30.0;
  static const stopVelocity = 1;

  final Vector2 initialPosition;
  late final BoulesBowlSprite sprite;
  final Player player;
  bool sleeping = true;
  bool readyToStop = false;

  double get r => radius;

  BoulesBowl(this.initialPosition, {required this.player})
      : super(renderBody: false) {
    sprite = BoulesBowlSprite(
      radius: r,
      color: player is NoPlayer ? null : player.color,
    );
  }

  factory BoulesBowl.fromJson(Map<String, dynamic> json) {
    var position = Vector2(json['position']['x'], json['position']['y']);
    if (json['player'] as int == Player.none.id) {
      return BoulesJack(position);
    }
    // ignore: prefer-returning-conditional-expressions
    return BoulesBowl(
      position,
      player: TeamAware.getPlayer(json['player'] as int),
    );
  }

  Map<String, dynamic> toJson() {
    Vector2 position = isLoaded ? body.position : initialPosition;
    return {
      'player': player.id,
      'position': {'x': position.x, 'y': position.y},
    };
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = r;
    final fixtureDef = FixtureDef(shape)
      ..density = 0.5
      ..friction = 0.3
      ..restitution = 1.0;
    final bodyDef = BodyDef(
      userData: this,
      linearDamping: 0.8,
      angularDamping: 0.8,
      position: initialPosition,
      type: BodyType.dynamic,
    );
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..setSleepingAllowed(true);
  }

  @override
  Future<void> onLoad() {
    add(sprite);
    return super.onLoad();
  }

  void launchTowards(Vector2 target) {
    final direction = target - body.position;
    final impulse = direction * launchImpulseFactor;
    body.applyLinearImpulse(impulse);
  }

  @override
  void update(double dt) {
    if (body.linearVelocity.length2 < stopVelocity) {
      body.linearVelocity.setZero();
    }
    if (sleeping != !body.isAwake) {
      sleeping = !body.isAwake;
      // The bowl has started or stopped moving
      notifyListeners();
    }
    super.update(dt);
  }

  void prepareToStop() {
    readyToStop = true;
  }
}

class BoulesBowlSprite extends CustomSpriteComponent {
  BoulesBowlSprite({required double radius, Color? color})
      : super(
          'boules/bowl.png',
          Vector2.zero(),
          anchor: Anchor.center,
          size: Vector2.all(radius * 2),
          hasShadow: true,
          color: color,
        ) {
    priority = 10;
  }
}
