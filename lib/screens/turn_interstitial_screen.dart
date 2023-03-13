import 'package:flutter/material.dart';

import '/common/common.dart';

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
        child: InterstitialAnimation(
          prefix: widget.gameFeatures.interstitialAnimationPath,
        ),
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
