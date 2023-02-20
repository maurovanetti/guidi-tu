import 'dart:math';

import 'package:flame/components.dart';
import 'package:guidi_tu/games/flame/battleship_item.dart';

import 'battleship_board.dart';
import 'battleship_module.dart';
import 'custom_sprite_component.dart';

class BattleshipShip extends BattleshipItem {
  BattleshipShip(
    Vector2 position, {
    required super.board,
    super.cellSpan = 1,
    super.isVertical = false,
  }) : super(
          'battleship/short_ship.png', // TODO Images for different sizes
          position,
          flipped: Random().nextBool(),
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'ship',
      'cellSpan': cellSpan,
      'isVertical': isVertical,
    };
  }
}
