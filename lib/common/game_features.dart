// We want to use the instances of game feature as globals.
// ignore_for_file: prefer-static-class

// This version of the app is in Italian only.
// ignore_for_file: avoid-non-ascii-symbols

import 'package:flutter/material.dart';

import '/games/turn_play.dart';
import '/games/battleship.dart';
import '/games/large_shot.dart';
import '/games/morra.dart';
import '/games/outcome_screen.dart';
import '/games/small_shot.dart';
import '/games/game_area.dart';
import 'config.dart' as config;
import 'move.dart';

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
  final GameArea Function({
    required void Function(bool) setReady,
    required MoveReceiver moveReceiver,
  }) buildGameArea;
  final TurnPlay Function() playWidget;
  final OutcomeScreen Function() outcomeWidget;
  final bool lessIsMore;
  final bool longerIsBetter;
  final bool pointsMatter;
  final String Function(int) formatPoints;
  final bool usesRigidGameArea;

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
    required this.buildGameArea,
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

  static String dontFormat(i) => i.toString();
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
  buildGameArea: LargeShotGameArea.new,
  playWidget: LargeShot.new,
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
  buildGameArea: SmallShotGameArea.new,
  playWidget: SmallShot.new,
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
  buildGameArea: MorraGameArea.new,
  playWidget: Morra.new,
  outcomeWidget: MorraOutcome.new,
  lessIsMore: true,
  // meaning the difference between the sum and the guess
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
  buildGameArea: BattleshipGameArea.new,
  playWidget: Battleship.new,
  outcomeWidget: BattleshipOutcome.new,
  formatPoints: (p) => '$p pt.',
  usesRigidGameArea: true,
);

final List<GameFeatures> allGameFeatures = [
  largeShot,
  smallShot,
  morra,
  battleship,
];
