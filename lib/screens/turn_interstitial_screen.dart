import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '../common/animation_loader.dart';

class TurnInterstitialScreen extends GameSpecificStatefulWidget {
  const TurnInterstitialScreen({super.key, required super.gameFeatures});

  @override
  TurnInterstitialState createState() => TurnInterstitialState();
}

class TurnInterstitialState extends TrackedState<TurnInterstitialScreen> {
  late Player player;

  @override
  void initState() {
    player = TurnAware.currentPlayer;
    super.initState();
  }

  void _play() {
    Navigation.replaceAll(context, widget.gameFeatures.playWidget).go();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.gameFeatures.name)),
      body: Center(
        child: InterstitialAnimation(gameFeatures: widget.gameFeatures),
      ),
      floatingActionButton: CustomFloatingActionButton(
        key: WidgetKeys.toTurnPlay,
        tooltip: 'Gioca',
        icon: Icons.play_arrow_rounded,
        onPressed: _play,
      ),
    );
  }
}

class InterstitialAnimation extends StatefulWidget {
  static const int fps = 10;

  final GameFeatures gameFeatures;

  const InterstitialAnimation({super.key, required this.gameFeatures});

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
    String path = widget.gameFeatures.interstitialAnimationPath;
    if (path.isEmpty) {
      debugPrint("No interstitial animation for ${widget.gameFeatures.name}");
      return;
    }
    var animation =
        await AnimationLoader.load(path, fps: InterstitialAnimation.fps);
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
