import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '/games/flame/custom_sprite_component.dart';

class ChallengeGoal extends BodyComponent with ContactCallbacks {
  late ChallengeGoalSprite sprite;

  final Vector2 initialPosition;
  final Vector2 size;
  final Anchor anchor;

  bool _hit = false;

  ChallengeGoal(
    this.initialPosition, {
    required this.anchor,
    required this.size,
  }) : super(renderBody: false) {
    sprite = ChallengeGoalSprite(
      Vector2.zero(),
      anchor: Anchor.center,
      size: size,
    );
  }

  @override
  Future<void> onLoad() {
    add(sprite);
    return super.onLoad();
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = size.x / 2;
    final fixtureDef = FixtureDef(
      shape,
      isSensor: true,
    );
    final bodyDef = BodyDef(
      userData: this,
      position: initialPosition,
      type: BodyType.static,
    );
    switch (anchor) {
      case Anchor.topLeft:
        bodyDef.position += size / 2;
        break;

      case Anchor.bottomRight:
        bodyDef.position -= size / 2;
        break;

      default:
        throw UnimplementedError("Other anchors are not expected here");
    }
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (!_hit) {
      unawaited(sprite.flash());
      super.beginContact(other, contact);
      _hit = true;
      // Can be hit only once
    }
  }
}

class ChallengeGoalSprite extends CustomSpriteComponent {
  ChallengeGoalSprite(
    absolutePosition, {
    required Anchor anchor,
    super.size,
  }) : super(
          'challenge/goal.png',
          absolutePosition,
          anchor: anchor,
          priority: 1,
          elevation: 1 / 3,
        );
}
