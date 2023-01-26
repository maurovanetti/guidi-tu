import 'package:flutter/material.dart';

import '../common/bubble.dart';
import '/common/custom_button.dart';
import '/common/game_features.dart';
import '/common/gap.dart';
import '/common/navigation.dart';
import '/common/player.dart';
import '/common/team_aware.dart';
import '/common/turn_aware.dart';

class TurnInterstitial extends StatefulWidget {
  final GameFeatures gameFeatures;

  const TurnInterstitial({super.key, required this.gameFeatures});

  @override
  TurnInterstitialState createState() => TurnInterstitialState();
}

class TurnInterstitialState extends State<TurnInterstitial>
    with TeamAware, TurnAware {
  Player player = NoPlayer();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await nextTurn();
      setState(() {
        player = TurnAware.currentPlayer;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameFeatures.name),
      ),
      body: WithBubbles(
        n: 5,
        behind: true,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Text("Tocca a",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge),
              PlayerTag(player),
              const Gap(),
              Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                  children: [
                    Text(widget.gameFeatures.explanation,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge),
                    const Text(
                        textAlign: TextAlign.center,
                        'A pari merito, conta la velocità.'),
                  ],
                ),
              ),
              const Gap(),
              if (player is! NoPlayer)
                CustomButton(
                  text: player.t("Sono pronto", "Sono pronta"),
                  onPressed: Navigation.replaceLast(
                      context, () => widget.gameFeatures.playWidget).go,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
