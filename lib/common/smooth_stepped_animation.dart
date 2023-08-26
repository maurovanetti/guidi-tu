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

  final List<({int start, int end})> transitions;
  final ValueListenable<int> page;

  @override
  SmoothSteppedAnimationState createState() => SmoothSteppedAnimationState();
}

class SmoothSteppedAnimationState extends InterstitialAnimationState {
  @override
  void repeatAnimation() {
    var a = animationTicker!;
    a.onFrame = (frame) {
      var w = widget as SmoothSteppedAnimation;
      int currentStep = w.page.value;
      int loopStart, loopEnd;
      if (currentStep == 0) {
        loopStart = 0;
        loopEnd = w.transitions.first.start;
      } else if (currentStep < w.transitions.length) {
        loopStart = w.transitions[currentStep - 1].end + 1;
        loopEnd = w.transitions[currentStep].start;
      } else {
        loopStart = w.transitions.last.end + 1;
        loopEnd = a.spriteAnimation.frames.length - 1;
      }
      if (frame >= loopEnd) {
        a.currentIndex = loopStart;
        a.clock = a.spriteAnimation.frames[loopStart].stepTime;
        a.elapsed = a.totalDuration();
        a.update(0);
      }
    };
  }
}
