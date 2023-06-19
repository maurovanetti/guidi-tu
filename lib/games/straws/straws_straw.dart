import 'package:flame/components.dart';
import 'package:flame/experimental.dart';

import 'straws_module.dart';

class StrawsStraw extends NineTileBoxComponent
    with HasGameReference<StrawsModule> {
  get span => size.x;

  StrawsStraw(
    Vector2 from, {
    required double angle,
    required double length,
    required Sprite sprite,
  }) : super(
          nineTileBox: NineTileBox(sprite),
          position: from,
          angle: angle,
          anchor: Anchor.centerLeft,
          size: Vector2(length, 10),
        );
}
