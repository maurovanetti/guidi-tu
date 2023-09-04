import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/forge2d_game.dart';

import 'steady_hand_ball.dart';
import 'steady_hand_platform.dart';

class SteadyHandModule extends Forge2DGame {
  final void Function() notifyFallen;

  SteadyHandModule({
    required this.notifyFallen,
  }) : super(gravity: Vector2.zero());

  @override
  Color backgroundColor() => const Color.fromRGBO(0, 0, 0, 1);

  Component createPlatform() => SteadyHandPlatform(
        size / 2,
        radius: size.x * (1 - 1 / 10) / 2,
      );

  Vector2 ballInitialPosition() {
    const ballOffset = 0;
    return size * ((ballOffset + 1) / 2);
  }

  double get ballRadius => 3.0;

  @override
  void onLoad() {
    super.onLoad();
    var platform = createPlatform();
    var ball = SteadyHandBall(
      ballInitialPosition(),
      platform,
      radius: ballRadius,
      notifyFallen: notifyFallen,
    );
    // ignore: avoid-async-call-in-sync-function
    add(platform);
    // ignore: avoid-async-call-in-sync-function
    add(ball);
    // ignore: avoid-async-call-in-sync-function
  }
}
