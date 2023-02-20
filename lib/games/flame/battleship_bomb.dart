import 'package:flame/components.dart';

import 'battleship_item.dart';

class BattleshipBomb extends BattleshipItem {
  BattleshipBomb(
    Vector2 position, {
    required super.board,
  }) : super(
          'battleship/bomb.png',
          position,
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'bomb',
    };
  }
}
