// This version of the app is in Italian only.
// ignore_for_file: avoid-non-ascii-symbols

import 'package:flutter/material.dart';

import '/common/common.dart';
import 'title_screen.dart';

class TurnInterstitialScreen extends GameSpecificStatefulWidget {
  const TurnInterstitialScreen({super.key, required super.gameFeatures});

  @override
  TurnInterstitialState createState() => TurnInterstitialState();
}

class TurnInterstitialState extends TrackedState<TurnInterstitialScreen>
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
        key: WidgetKeys.hiddenPlayAlert,
        title: const Text("Gioca di nascosto"),
        content: const Text("Non mostrare la tua mossa agli altri."),
        actions: [
          TextButton(
            key: WidgetKeys.acknowledgeHiddenPlay,
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
                content: const Text(
                  "Vuoi davvero interrompere il gioco?\n"
                  "Farai una figura da guastafeste!",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Continua a giocare"),
                  ),
                  TextButton(
                    onPressed: Navigation.replaceAll(
                      context,
                      () => const TitleScreen(),
                    ).go,
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
                    'A pari merito, conta la velocità.',
                  ),
                ],
              ),
            ),
            bottomChildren: [
              const Gap(),
              if (player is! NoPlayer)
                CustomButton(
                  key: WidgetKeys.toTurnPlay,
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
