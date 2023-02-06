import 'package:flutter/material.dart';

import '/common/bubble.dart';
import '/common/custom_button.dart';
import '/common/game_aware.dart';
import '/common/gap.dart';
import '/common/gender.dart';
import '/common/navigation.dart';
import '/common/team_aware.dart';

class CompletionScreen extends GameSpecificStatefulWidget {
  const CompletionScreen({super.key, required super.gameFeatures});

  @override
  CompletionScreenState createState() => CompletionScreenState();
}

class CompletionScreenState extends GameSpecificState<CompletionScreen>
    with Gendered, TeamAware {
  Future<void> _displayOutcome() async {
    if (mounted) {
      Navigation.replaceAll(context, widget.gameFeatures.outcomeWidget).go();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t("Hanno giocato tutti", "Hanno giocato tutte",
            "Ogni persona ha giocato")),
      ),
      body: WithSquares(
        behind: true,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("I risultati finali sono pronti…",
                  style: Theme.of(context).textTheme.headlineLarge),
              const Gap(),
              CustomButton(
                text: "Vediamoli!",
                onPressed: _displayOutcome,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
