// ignore_for_file: avoid-non-ascii-symbols

import 'package:flutter/material.dart';

import '/common/common.dart';

class CompletionScreen extends GameSpecificStatefulWidget {
  const CompletionScreen({super.key, required super.gameFeatures});

  @override
  CompletionScreenState createState() => CompletionScreenState();
}

class CompletionScreenState extends ForwardOnlyState<CompletionScreen>
    with Gendered, TeamAware {
  void _handleDisplayOutcome() {
    if (mounted) {
      Navigation.replaceAll(context, widget.gameFeatures.onBuildOutcomeScreen)
          .go();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t(
          "Hanno giocato tutti",
          "Hanno giocato tutte",
          "Ogni persona ha giocato",
        )),
      ),
      body: WithBubbles(
        behind: true,
        child: Padding(
          padding: StyleGuide.widePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "I risultati finali sono pronti…",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const Gap(),
              CustomButton(
                key: WidgetKeys.toOutcome,
                text: "Vediamoli!",
                onPressed: _handleDisplayOutcome,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
