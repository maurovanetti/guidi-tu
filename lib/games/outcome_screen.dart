import 'package:flutter/material.dart';

import '/common/custom_fab.dart';
import '/common/game_aware.dart';
import '/common/gender.dart';
import '/common/navigation.dart';
import '/common/score_aware.dart';
import '/common/team_aware.dart';
import 'placement_screen.dart';

class OutcomeScreen extends GameSpecificStatefulWidget {
  const OutcomeScreen({super.key, required super.gameFeatures});

  @override
  OutcomeScreenState createState() => OutcomeScreenState();
}

class OutcomeScreenState extends GameSpecificState<OutcomeScreen>
    with Gendered, TeamAware, ScoreAware {
  Future<void> _revealPlacement() async {
    if (mounted) {
      Navigation.replaceAll(context, () => const PlacementScreen()).go();
    }
  }

  // Override this to tailor the outcome screen
  Widget _buildOutcome() => buildPlaceHolder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Risultati"),
      ),
      body: _buildOutcome(),
      floatingActionButton: CustomFloatingActionButton(
        tooltip: "Classifica",
        icon: Icons.skip_next_rounded,
        onPressed: _revealPlacement,
      ),
    );
  }
}
