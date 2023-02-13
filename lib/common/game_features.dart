import 'package:flutter/material.dart';

import '/games/large_shot.dart';
import '/games/morra.dart';
import '/games/outcome_screen.dart';
import '/games/small_shot.dart';
import '/games/turn_play.dart';
import 'config.dart' as config;

class GameFeatures {
  final String name;
  final String description;
  final String explanation;
  final bool secretPlay;
  final IconData icon;
  final int minPlayers;
  final int maxPlayers;
  final int minSuggestedPlayers;
  final int maxSuggestedPlayers;
  final TurnPlay Function() playWidget;
  final OutcomeScreen Function() outcomeWidget;
  final bool lessIsMore;
  final bool longerIsBetter;
  final bool pointsMatter;
  final String Function(int) formatPoints;

  static String dontFormat(i) => i.toString();

  GameFeatures({
    required this.name,
    required this.description,
    required this.explanation,
    required this.icon,
    this.secretPlay = false,
    required this.minPlayers,
    int? maxPlayers,
    required this.minSuggestedPlayers,
    int? maxSuggestedPlayers,
    required this.playWidget,
    required this.outcomeWidget,
    this.lessIsMore = false,
    this.longerIsBetter = false,
    this.pointsMatter = true,
    this.formatPoints = dontFormat,
  })  : maxPlayers = maxPlayers ?? config.maxPlayers,
        maxSuggestedPlayers = maxSuggestedPlayers ?? config.maxPlayers {
    assert(minPlayers <= minSuggestedPlayers);
    assert(minSuggestedPlayers <= this.maxSuggestedPlayers);
    assert(this.maxSuggestedPlayers <= config.maxPlayers);
  }
}

final largeShot = GameFeatures(
  name: "Spararla grossa",
  description: "Scegli un numero alto.",
  explanation: """
Guidi tu se scegli il numero più basso.

Ma attenzione: chi sceglie il numero più alto, paga.""",
  secretPlay: true,
  icon: Icons.arrow_circle_up_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
  playWidget: () => LargeShot(),
  outcomeWidget: () => LargeShotOutcome(),
);

final smallShot = GameFeatures(
  name: "Cadere in basso",
  description: "Scegli un numero basso.",
  explanation: """
Guidi tu se scegli il numero più alto.

Ma attenzione: chi sceglie il numero più basso, paga.""",
  secretPlay: true,
  icon: Icons.arrow_circle_down_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
  playWidget: () => SmallShot(),
  outcomeWidget: () => SmallShotOutcome(),
  lessIsMore: true,
);

final morra = GameFeatures(
  name: "Morra",
  description: "Indovina la somma delle mani.",
  explanation: """
Scegli quante dita mostrare e prevedi quante dita saranno mostrate da tutti.
  
Guidi tu se ti avvicini di meno alla somma giusta.

Ma attenzione: chi si avvicina di più, paga.""",
  secretPlay: true,
  icon: Icons.back_hand_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
  playWidget: () => Morra(),
  outcomeWidget: () => MorraOutcome(),
  lessIsMore: true, // meaning the difference between the sum and the guess
  formatPoints: (p) => '±$p',
);

final List<GameFeatures> allGameFeatures = [largeShot, smallShot, morra];
