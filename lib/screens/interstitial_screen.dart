import 'package:flutter/material.dart';

import '/common/common.dart';
import 'turn_instructions_screen.dart';

class InterstitialScreen extends GameSpecificStatefulWidget {
  const InterstitialScreen({super.key, required super.gameFeatures});

  @override
  TurnInterstitialState createState() => TurnInterstitialState();
}

class TurnInterstitialState extends TrackedState<InterstitialScreen> {
  void _play() {
    Navigation.replaceAll(
      context,
      () => TurnInstructionsScreen(gameFeatures: widget.gameFeatures),
    ).go();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.gameFeatures.name)),
      body: Center(
        child: InterstitialAnimation(
          prefix: widget.gameFeatures.interstitialAnimationPath,
          repeat: widget.gameFeatures.interstitialAnimationRepeat,
          onComplete: _play,
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        key: WidgetKeys.toTurnInstructions,
        tooltip: 'Gioca',
        icon: Icons.play_arrow_rounded,
        onPressed: _play,
      ),
    );
  }
}
