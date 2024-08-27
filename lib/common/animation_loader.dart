import 'dart:ui';

import 'package:dart_code_metrics_annotations/annotations.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

abstract final class AnimationLoader {
  static const defaultFps = 10;

  @Throws()
  static Future<SpriteAnimation?> make(
    String path, {
    int? fps,
    bool loop = true,
  }) async {
    List<Image> frameImages = await load(path);
    List<Sprite> sprites = frameImages.map((image) => Sprite(image)).toList();
    return SpriteAnimation.spriteList(
      sprites,
      stepTime: 1 / (fps ?? defaultFps),
      loop: loop,
    );
  }

  // This exists as a separate method so that it can be used to precache long
  // animations.
  @Throws()
  static Future<List<Image>> load(String path) async {
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
    return frameImages;
  }
}
