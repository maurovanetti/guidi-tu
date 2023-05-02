import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/forge2d_game.dart';

import 'steady_hand_ball.dart';
import 'steady_hand_platform.dart';

class SteadyHandModule extends Forge2DGame {
  static const ballOffset = 1 / 4;

  final void Function() notifyFallen;

  SteadyHandModule({
    required this.notifyFallen,
  }) : super(gravity: Vector2.zero());

  @override
  Color backgroundColor() => const Color.fromRGBO(0, 0, 0, 1);

  @override
  Future<void> onLoad() async {
    add(SteadyHandPlatform(
      size / 2,
      radius: size.x * (1 - 1 / 10) / 2,
    ));
    add(SteadyHandBall(
      size * ((ballOffset + 1) / 2),
      notifyFallen: notifyFallen,
    ));
    super.onLoad();
  }
}
