import 'package:flutter/material.dart';

import '/games/large_shot.dart';
import '/games/morra.dart';
import '/games/placement_screen.dart';
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
  final TurnPlay playWidget;
  final PlacementScreen placementWidget;
  final bool lessIsMore;

  const GameFeatures({
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
    required this.placementWidget,
    this.lessIsMore = false,
  })  : maxPlayers = maxPlayers ?? config.maxPlayers,
        maxSuggestedPlayers = maxSuggestedPlayers ?? config.maxPlayers;
}

const largeShot = GameFeatures(
  name: "Spararla grossa",
  description: "Scegli un numero alto.",
  explanation: """
Guidi tu se scegli il numero più basso.

Ma attenzione: chi sceglie il numero più alto, paga.""",
  secretPlay: true,
  icon: Icons.arrow_circle_up_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
  playWidget: LargeShot(),
  placementWidget: PlacementScreen(),
);

const smallShot = GameFeatures(
  name: "Cadere in basso",
  description: "Scegli un numero basso.",
  explanation: """
Guidi tu se scegli il numero più alto.

Ma attenzione: chi sceglie il numero più basso, paga.""",
  secretPlay: true,
  icon: Icons.arrow_circle_down_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
  playWidget: SmallShot(),
  placementWidget: PlacementScreen(),
  lessIsMore: true,
);

const morra = GameFeatures(
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
  playWidget: Morra(),
  placementWidget: PlacementScreen(),
  lessIsMore: true, // meaning the difference between the sum and the guess
);

const allGameFeatures = [
  largeShot,
  smallShot,
  morra,
];
