// This version of the app is in Italian only.
// ignore_for_file: avoid-non-ascii-symbols

import 'package:flutter/material.dart';
import 'package:guidi_tu/common/squeeze_or_scroll.dart';

import '/common/custom_button.dart';
import '/common/game_aware.dart';
import '/common/gap.dart';
import '/common/gender.dart';
import '/common/navigation.dart';
import '/common/player.dart';
import '/common/style_guide.dart';
import '/common/team_aware.dart';
import '/common/tracked_state.dart';
import '/common/turn_aware.dart';
import '/common/widget_keys.dart';
import '/common/with_bubbles.dart';
import '/home_page.dart';

class TurnInterstitial extends GameSpecificStatefulWidget {
  const TurnInterstitial({super.key, required super.gameFeatures});

  @override
  TurnInterstitialState createState() => TurnInterstitialState();
}

class TurnInterstitialState extends TrackedState<TurnInterstitial>
    with Gendered, TeamAware, TurnAware {
  late Player player;

  @override
  void initState() {
    player = TurnAware.currentPlayer;
    super.initState();
  }

  void _showSecretPlayAlert() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        key: hiddenPlayAlertWidgetKey,
        title: const Text("Gioca di nascosto"),
        content: const Text("Non mostrare la tua mossa agli altri."),
        actions: [
          TextButton(
            key: acknowledgeHiddenPlayWidgetKey,
            onPressed: _play,
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _play() {
    Navigation.replaceAll(context, widget.gameFeatures.playWidget).go();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameFeatures.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel_rounded),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Interruzione del gioco"),
                content: const Text("Vuoi davvero interrompere il gioco?\n"
                    "Farai una figura da guastafeste!"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Continua a giocare"),
                  ),
                  TextButton(
                    onPressed:
                        Navigation.replaceAll(context, () => const HomePage())
                            .go,
                    child: const Text("Ferma tutto"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: WithBubbles(
        n: 5,
        behind: true,
        child: Center(
          child: SqueezeOrScroll(
            // Squeezing it does not work right now because the text does not
            // resize. In order to do that some changes to the text widget are
            // needed.
            squeeze: false,
            topChildren: [
              Text(
                "Tocca a",
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge,
              ),
              PlayerTag(player),
              const Gap(),
            ],
            centralChild: Padding(
              padding: StyleGuide.widePadding,
              child: Column(
                children: [
                  Text(
                    widget.gameFeatures.description,
                    textAlign: TextAlign.center,
                    style: textTheme.headlineLarge,
                  ),
                  const Gap(),
                  Text(
                    widget.gameFeatures.explanation,
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge,
                  ),
                  const Gap(),
                  const Text(
                      textAlign: TextAlign.center,
                      'A pari merito, conta la velocità.'),
                ],
              ),
            ),
            bottomChildren: [
              const Gap(),
              if (player is! NoPlayer)
                CustomButton(
                  key: toTurnPlayWidgetKey,
                  text: player.t("Sono pronto", "Sono pronta"),
                  onPressed: widget.gameFeatures.secretPlay
                      ? _showSecretPlayAlert
                      : _play,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
