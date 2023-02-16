import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

import 'battleship_module.dart';

class BattleshipShip extends SpriteComponent
    with HasGameReference<BattleshipModule> {
  BattleshipShip() : super(size: Vector2.all(128.0));

  @override
  Future<void> onLoad() async {
    sprite = await game.loadSprite('battleship/short_ship.png');
    position = game.size / 3;
  }
}
