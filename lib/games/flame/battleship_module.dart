import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'battleship_ship.dart';

class BattleshipModule extends FlameGame with HasDraggables {
  @override
  Color backgroundColor() => Colors.blue.shade900;

  @override
  Future<void> onLoad() async {
    await add(BattleshipShip(size / 2));
  }
}
