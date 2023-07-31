import 'package:flame/sprite.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

import 'animation_loader.dart';

class InterstitialAnimation extends StatefulWidget {
  const InterstitialAnimation({
    super.key,
    required this.prefix,
    this.repeat = 1,
    this.onComplete,
  });

  static const int fps = 20;

  final String prefix;
  final num repeat;
  final VoidCallback? onComplete;

  @override
  InterstitialAnimationState createState() => InterstitialAnimationState();
}

class InterstitialAnimationState extends State<InterstitialAnimation> {
  SpriteAnimationTicker? animationTicker;
  late num _animationCount;

  @override
  void initState() {
    super.initState();
    _animationCount = widget.repeat;
    _loadAnimation();
  }

  Future<void> _loadAnimation() async {
    if (widget.prefix.isEmpty) {
      debugPrint("No interstitial animation in ${widget.prefix}_*.png");
      return;
    }
    SpriteAnimation animation = (await AnimationLoader.load(
      widget.prefix,
      fps: InterstitialAnimation.fps,
      loop: true,
    ))!;
    debugPrint("Interstitial animation loaded: ${widget.prefix}_*.png");
    if (mounted) {
      setState(() {
        animationTicker = SpriteAnimationTicker(animation);
      });
      _repeatAnimation();
    }
  }

  void _repeatAnimation() {
    var a = animationTicker!;
    a.onFrame = (frame) {
      if (a.isLastFrame) {
        _animationCount--;
        if (_animationCount <= 0) {
          a.spriteAnimation.loop = false;
          widget.onComplete?.call();
        }
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: animationTicker == null
          ? const SizedBox.shrink()
          : SpriteAnimationWidget(
              animationTicker: animationTicker!,
              animation: animationTicker!.spriteAnimation,
            ),
    );
  }
}
