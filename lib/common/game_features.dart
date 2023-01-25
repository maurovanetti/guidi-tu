import 'package:flutter/material.dart';

import '/games/large_shot.dart';
import '/games/morra.dart';
import '/games/small_shot.dart';
import '/games/awards.dart';
import '/games/turn_play.dart';
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
  final TurnPlay playWidget; // TODO required and not null
  final Awards? awardsWidget; // TODO required and not null

  const GameFeatures({
    required this.name,
    required this.description,
    required this.explanation,
    required this.icon,
    required this.minPlayers,
    int? maxPlayers,
    required this.minSuggestedPlayers,
    int? maxSuggestedPlayers,
    required this.playWidget,
    this.awardsWidget,
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
  playWidget: LargeShot(),
  // awardsWidget: const LargeShotAwards(),
);

const smallShot = GameFeatures(
  name: "Cadere in basso",
  description: "Scegli il numero più basso.",
  explanation: "Guida chi sceglie il numero più alto.\n"
      "Paga chi sceglie il numero più basso.",
  icon: Icons.arrow_circle_down_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
  playWidget: SmallShot(),
  // awardsWidget: const SmallShotAwards(),
);

const morra = GameFeatures(
  name: "Morra",
  description: "Indovina la somma delle mani.",
  explanation: "Guida chi si avvicina di meno alla somma.\n"
      "Paga chi si avvicina di più.",
  icon: Icons.back_hand_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
  playWidget: Morra(),
  // awardsWidget: const MorraAwards(),
);

const allGameFeatures = [
  largeShot,
  smallShot,
  morra,
];
