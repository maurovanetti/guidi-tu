import 'package:flame/sprite.dart';
import 'package:flutter/foundation.dart';

import 'interstitial_animation.dart';

class SmoothSteppedAnimation extends InterstitialAnimation {
  const SmoothSteppedAnimation({
    super.key,
    required super.prefix,
    super.repeat = double.infinity,
    super.fps = 10,
    required this.transitions,
    required this.page,
  });

  final List<(int, int)> transitions;
  final ValueListenable<int> page;

  @override
  SmoothSteppedAnimationState createState() => SmoothSteppedAnimationState();
}

class SmoothSteppedAnimationState extends InterstitialAnimationState {
  _changeFrame(SpriteAnimationTicker a, int frameIndex) {
    a.currentIndex = frameIndex;
    a.clock = a.spriteAnimation.frames[frameIndex].stepTime;
    a.elapsed = a.totalDuration();
    a.update(0);
  }

  @override
  void repeatAnimation() {
    var a = animationTicker!;
    a.onFrame = (frame) {
      var w = widget as SmoothSteppedAnimation;
      int currentStep = w.page.value;
      int loopStart, loopEnd;
      if (currentStep == 0) {
        loopStart = 0;
        loopEnd = w.transitions.first.$1;
      } else if (currentStep < w.transitions.length) {
        loopStart = w.transitions[currentStep - 1].$2 + 1;
        loopEnd = w.transitions[currentStep].$1;
      } else {
        loopStart = w.transitions.last.$2 + 1;
        loopEnd = a.spriteAnimation.frames.length - 1;
      }
      if (frame >= loopEnd) {
        // ignore: avoid-ignoring-return-values
        _changeFrame(a, loopStart);
      }
    };
  }
}
