import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'battleship_ship.dart';

class BattleshipModule extends FlameGame {
  @override
  Color backgroundColor() => Colors.blue.shade900;

  @override
  Future<void> onLoad() async {
    debugPrint('BattleshipModule.onLoad()');
    await add(BattleshipShip());
  }
}
