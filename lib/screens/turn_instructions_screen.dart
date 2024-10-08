// This version of the app is in Italian only.
// ignore_for_file: avoid-non-ascii-symbols

import 'dart:async';

import 'package:flutter/material.dart';

import '/common/common.dart';

class TurnInstructionsScreen extends GameSpecificStatefulWidget {
  const TurnInstructionsScreen({super.key, required super.gameFeatures});

  @override
  TurnInstructionsScreenState createState() => TurnInstructionsScreenState();
}

class TurnInstructionsScreenState
    extends ForwardOnlyState<TurnInstructionsScreen>
    with Gendered, TeamAware, TurnAware {
  late Player player;

  @override
  void initState() {
    super.initState();
    player = TurnAware.currentPlayer;
  }

  void _handleSecretPlay() {
    unawaited(showDialog(
      context: context,
      builder: (context) => AlertDialog(
        key: WidgetKeys.hiddenPlayAlert,
        title: Text($.playSecretlyTitle),
        content: Text($.playSecretly),
        actions: [
          TextButton(
            key: WidgetKeys.acknowledgeHiddenPlay,
            onPressed: _handlePlay,
            child: Text($.ok),
          ),
        ],
      ),
    ));
  }

  void _handlePlay() {
    Navigation.replaceAll(context, widget.gameFeatures.onBuildTurnPlayScreen)
        .go();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.gameFeatures.name($)),
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel_rounded),
            onPressed: handleQuit,
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
            topChildren: [
              Text(
                $.itsTurnOf,
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
                    widget.gameFeatures.description($),
                    textAlign: TextAlign.center,
                    style: textTheme.headlineLarge,
                  ),
                  const Gap(),
                  Text(
                    widget.gameFeatures.explanation($),
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge,
                  ),
                  if (widget.gameFeatures.externalClock) ...[
                    const Gap(),
                    Text(
                      $.tieBreaker,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            bottomChildren: [
              const Gap(),
              if (player is! NoPlayer)
                CustomButton(
                  key: WidgetKeys.toTurnPlay,
                  text: player.t($.iAmReady),
                  onPressed: widget.gameFeatures.secretPlay
                      ? _handleSecretPlay
                      : _handlePlay,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
