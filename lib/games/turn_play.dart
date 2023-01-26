import 'package:flutter/material.dart';

import '/common/game_features.dart';
import '/common/custom_button.dart';
import '/common/navigation.dart';
import '/common/gap.dart';
import '/common/player.dart';
import '/common/team_aware.dart';
import '/common/turn_aware.dart';
import '/games/turn_interstitial.dart';

abstract class TurnPlay extends StatefulWidget {
  GameFeatures get gameFeatures;

  const TurnPlay({super.key});

  @override
  TurnPlayState createState() => TurnPlayState();
}

class TurnPlayState extends State<TurnPlay> with TeamAware, TurnAware {
  void _completeTurn() async {
    var hasEveryonePlayed = !await nextTurn();
    if (mounted) {
      if (hasEveryonePlayed) {
        Navigation.replaceLast(
            context, () => widget.gameFeatures.placementWidget).go();
      } else {
        Navigation.replaceLast(context,
            () => TurnInterstitial(gameFeatures: widget.gameFeatures)).go();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameFeatures.name),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            PlayerTag(TurnAware.currentPlayer),
            const Text("CONTATEMPO"),
            const Gap(),
            const Text("AREA DI GIOCO"),
            const Gap(),
            CustomButton(
              text: "Ho finito!",
              onPressed: _completeTurn,
            ),
          ],
        ),
      ),
    );
  }
}
