import 'dart:async';
import 'dart:ui';

import 'package:flame/game.dart';

class SteadyHandModule extends FlameGame {
  final void Function() notifyFallen;

  SteadyHandModule({
    required this.notifyFallen,
  });

  @override
  Color backgroundColor() => const Color.fromRGBO(0, 0, 0, 1);

  @override
  Future<void> onLoad() async {}
}
