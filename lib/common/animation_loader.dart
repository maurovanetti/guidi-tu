import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class AnimationLoader {
  static const defaultFps = 10;

  static Future<SpriteAnimation?> load(
    String path, {
    int? fps,
    bool loop = true,
  }) async {
    // Lower case is required because Flame.images.loadAllFromPattern assumes
    // lower-case pattern matching.
    // ignore: avoid-mutating-parameters
    path = path.toLowerCase();
    List<Image> frameImages = await Flame.images
        .loadAllFromPattern(RegExp('${RegExp.escape(path)}[_\\-]\\d+\\.png'));
    if (frameImages.isEmpty) {
      throw Exception(
        "No animation frames found in ${path}_*.png or $path-*.png",
      );
    }
    List<Sprite> sprites = frameImages.map((image) => Sprite(image)).toList();
    return SpriteAnimation.spriteList(
      sprites,
      stepTime: 1 / (fps ?? defaultFps),
      loop: loop,
    );
  }
}
