import 'dart:async';

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
    this.fps = defaultFps,
  });

  static const defaultFps = 20;

  final int fps;
  final String prefix;
  final num repeat;
  final VoidCallback? onComplete;

  @override
  InterstitialAnimationState createState() => InterstitialAnimationState();
}

class InterstitialAnimationState extends State<InterstitialAnimation> {
  @protected
  SpriteAnimationTicker? animationTicker;
  late num _animationCount;

  @override
  void initState() {
    super.initState();
    _animationCount = widget.repeat;
    unawaited(_loadAnimation());
  }

  Future<void> _loadAnimation() async {
    if (widget.prefix.isEmpty) {
      debugPrint("No interstitial animation in ${widget.prefix}_*.png");
      return;
    }
    SpriteAnimation animation = (await AnimationLoader.make(
      widget.prefix,
      fps: widget.fps,
      loop: true,
    ))!;
    debugPrint("Interstitial animation loaded: ${widget.prefix}_*.png");
    if (mounted) {
      setState(() {
        animationTicker = SpriteAnimationTicker(animation);
      });
      repeatAnimation();
    }
  }

  @override
  dispose() {
    animationTicker == null;
    super.dispose();
  }

  @protected
  void repeatAnimation() {
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
