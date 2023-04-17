import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

import 'animation_loader.dart';

class InterstitialAnimation extends StatefulWidget {
  static const int fps = 10;

  final String prefix;
  final num repeat;
  final VoidCallback? onComplete;

  const InterstitialAnimation({
    super.key,
    required this.prefix,
    this.repeat = 1,
    this.onComplete,
  });

  @override
  InterstitialAnimationState createState() => InterstitialAnimationState();
}

class InterstitialAnimationState extends State<InterstitialAnimation> {
  SpriteAnimation? animation;
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
    var animation = await AnimationLoader.load(
      widget.prefix,
      fps: InterstitialAnimation.fps,
      loop: true,
    );
    debugPrint("Interstitial animation loaded: ${widget.prefix}_*.png");
    if (mounted) {
      setState(() {
        this.animation = animation;
      });
      _repeatAnimation();
    }
  }

  void _repeatAnimation() {
    var a = animation!;
    a.onFrame = (frame) {
      if (a.isLastFrame) {
        _animationCount--;
        if (_animationCount <= 0) {
          a.loop = false;
          widget.onComplete?.call();
        }
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: animation == null
          ? const SizedBox.shrink()
          : SpriteAnimationWidget(animation: animation!),
    );
  }
}
