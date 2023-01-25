import 'package:flutter/material.dart';

import 'config.dart' as config;

class GameFeatures {
  final String name;
  final String description;
  final String explanation;
  final IconData icon;
  final int minPlayers;
  final int maxPlayers;
  final int minSuggestedPlayers;
  final int maxSuggestedPlayers;

  const GameFeatures({
    required this.name,
    required this.description,
    required this.explanation,
    required this.icon,
    required this.minPlayers,
    int? maxPlayers,
    required this.minSuggestedPlayers,
    int? maxSuggestedPlayers,
  })  : maxPlayers = maxPlayers ?? config.maxPlayers,
        maxSuggestedPlayers = maxSuggestedPlayers ?? config.maxPlayers;
}

const largeShot = GameFeatures(
  name: "Spararla grossa",
  description: "Scegli il numero più alto.",
  explanation: "Guida chi sceglie il numero più basso.\n"
      "Paga chi sceglie il numero più alto.",
  icon: Icons.arrow_circle_up_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
);

const smallShot = GameFeatures(
  name: "Cadere in basso",
  description: "Scegli il numero più basso.",
  explanation: "Guida chi sceglie il numero più alto.\n"
      "Paga chi sceglie il numero più basso.",
  icon: Icons.arrow_circle_down_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
);

const morra = GameFeatures(
  name: "Morra",
  description: "Indovina la somma delle mani.",
  explanation: "Guida chi si avvicina di meno alla somma.\n"
      "Paga chi si avvicina di più.",
  icon: Icons.back_hand_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
);
