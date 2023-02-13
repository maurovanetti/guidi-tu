import 'package:flutter/material.dart';

import '/common/custom_fab.dart';
import '/common/game_aware.dart';
import '/common/gender.dart';
import '/common/navigation.dart';
import '/common/score_aware.dart';
import '/common/team_aware.dart';
import '/common/turn_aware.dart';
import 'placement_screen.dart';

abstract class OutcomeScreen extends GameSpecificStatefulWidget {
  const OutcomeScreen({super.key, required super.gameFeatures});

  @override
  OutcomeScreenState createState();
}

abstract class OutcomeScreenState<T extends Move>
    extends GameSpecificState<OutcomeScreen>
    with Gendered, TeamAware, ScoreAware, TurnAware<T> {
  void _revealPlacement() {
    for (var player in players) {
      var score = Score(
        points: getPoints(player),
        time: getTime(player),
        lessIsMore: widget.gameFeatures.lessIsMore,
        longerIsBetter: widget.gameFeatures.longerIsBetter,
        pointsMatter: widget.gameFeatures.pointsMatter,
        formatPoints: widget.gameFeatures.formatPoints,
      );
      ScoreAware.recordScore(player, score);
      debugPrint("${player.name} scored ${ScoreAware.scores[player]} "
          "at ${widget.gameFeatures.name}");
    }
    if (mounted) {
      Navigation.replaceAll(context, () => const PlacementScreen()).go();
    }
  }

  // Override this to tailor the outcome screen
  Widget buildOutcome() => buildPlaceHolder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Risultati"),
      ),
      body: buildOutcome(),
      floatingActionButton: CustomFloatingActionButton(
        tooltip: "Classifica",
        icon: Icons.skip_next_rounded,
        onPressed: _revealPlacement,
      ),
    );
  }
}
