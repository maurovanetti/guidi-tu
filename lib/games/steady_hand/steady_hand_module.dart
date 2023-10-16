import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/forge2d_game.dart';

import 'steady_hand_ball.dart';
import 'steady_hand_platform.dart';

class SteadyHandModule extends Forge2DGame {
  final void Function() notifyFallen;
  final ballGravityMultiplier = 50.0;
  final ballRadius = 3.0;

  Rect get view => camera.visibleWorldRect;

  SteadyHandModule({
    required this.notifyFallen,
  }) : super(gravity: Vector2.zero());

  @override
  Color backgroundColor() => const Color.fromRGBO(0, 0, 0, 1);

  Component createPlatform() => SteadyHandPlatform(
        view.center.toVector2(),
        radius: view.width * (1 - 1 / 10) / 2,
      );

  Vector2 ballInitialPosition() => view.center.toVector2();

  @override
  void onLoad() {
    var platform = createPlatform();
    var ball = SteadyHandBall(
      ballInitialPosition(),
      platform,
      radius: ballRadius,
      finalGravityMultiplier: ballGravityMultiplier,
      notifyFallen: notifyFallen,
    );
    // ignore: avoid-async-call-in-sync-function
    world.add(platform);
    // ignore: avoid-async-call-in-sync-function
    world.add(ball);
  }
}
