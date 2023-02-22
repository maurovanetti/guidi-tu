import 'package:flutter/material.dart';
import 'package:guidi_tu/common/widget_keys.dart';

import '/games/large_shot.dart';
import '/games/morra.dart';
import '/games/outcome_screen.dart';
import '/games/small_shot.dart';
import '/games/turn_play.dart';
import '../games/battleship.dart';
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
  final bool usesRigidGameArea;

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
    this.usesRigidGameArea = false,
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
  minSuggestedPlayers: 3,
  playWidget: () => LargeShot(key: largeShotWidgetKey),
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
  minSuggestedPlayers: 3,
  playWidget: () => SmallShot(key: smallShotWidgetKey),
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
  playWidget: () => Morra(key: morraWidgetKey),
  outcomeWidget: () => MorraOutcome(),
  lessIsMore: true, // meaning the difference between the sum and the guess
  formatPoints: (p) => '±$p',
);

final battleship = GameFeatures(
  name: "Battaglia navale",
  description: "Salva le tue paperelle.",
  explanation: """
Scegli dove collocare le tue paperelle e i tuoi proiettili di sughero.

Fai ${Battleship.saveValue} punti per ogni tua paperella salvata, ${Battleship.sinkValue} per ogni paperella altrui che affondi. 
  
Guidi tu se fai meno punti.

Ma attenzione: chi fa più punti, paga.""",
  secretPlay: true,
  icon: Icons.sailing_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
  playWidget: () => Battleship(key: battleshipWidgetKey),
  outcomeWidget: () => BattleshipOutcome(),
  formatPoints: (p) => '$p pt.',
  usesRigidGameArea: true,
);

final List<GameFeatures> allGameFeatures = [
  largeShot,
  smallShot,
  morra,
  battleship,
];
