import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

import 'animation_loader.dart';

class InterstitialAnimation extends StatefulWidget {
  static const int fps = 10;

  final String prefix;

  const InterstitialAnimation({super.key, required this.prefix});

  @override
  InterstitialAnimationState createState() => InterstitialAnimationState();
}

class InterstitialAnimationState extends State<InterstitialAnimation> {
  SpriteAnimation? animation;

  @override
  void initState() {
    super.initState();
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
    );
    if (mounted) {
      setState(() {
        this.animation = animation;
      });
    }
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
