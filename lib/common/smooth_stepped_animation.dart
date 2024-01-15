import 'package:flutter/foundation.dart';

import 'interstitial_animation.dart';

class SmoothSteppedAnimation extends InterstitialAnimation {
  const SmoothSteppedAnimation({
    super.key,
    required super.prefix,
    super.repeat = double.infinity,
    super.fps = 10,
    required this.loops,
    required this.page,
  });

  final List<({int start, int end})> loops;
  final ValueListenable<int> page;

  @override
  SmoothSteppedAnimationState createState() => SmoothSteppedAnimationState();
}

class SmoothSteppedAnimationState extends InterstitialAnimationState {
  bool _beyondEnd = false;

  @override
  void repeatAnimation() {
    var a = animationTicker!;
    a.onFrame = (frame) {
      var w = widget as SmoothSteppedAnimation;
      int currentStep = w.page.value;
      if (currentStep >= w.loops.length) {
        currentStep = w.loops.length - 1;
      }
      int loopStart = w.loops[currentStep].start;
      int loopEnd = w.loops[currentStep].end;
      if (frame > loopEnd || _beyondEnd && a.isFirstFrame) {
        a.currentIndex = loopStart;
        a.clock = a.spriteAnimation.frames[loopStart].stepTime;
        a.elapsed = a.totalDuration();
        a.update(0);
      }
      _beyondEnd = a.isLastFrame;
    };
  }
}
