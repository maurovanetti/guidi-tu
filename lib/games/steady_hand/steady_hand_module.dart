import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/forge2d_game.dart';

import 'steady_hand_ball.dart';
import 'steady_hand_platform.dart';

class SteadyHandModule extends Forge2DGame {
  static const ballOffset = 0;

  final void Function() notifyFallen;

  SteadyHandModule({
    required this.notifyFallen,
  }) : super(gravity: Vector2.zero());

  @override
  Color backgroundColor() => const Color.fromRGBO(0, 0, 0, 1);

  @override
  Future<void> onLoad() async {
    var platform = SteadyHandPlatform(
      size / 2,
      radius: size.x * (1 - 1 / 10) / 2,
    );
    var ball = SteadyHandBall(
      size * ((ballOffset + 1) / 2),
      platform,
      notifyFallen: notifyFallen,
    );
    add(platform);
    add(ball);
    super.onLoad();
  }
}
