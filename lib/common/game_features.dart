// We want to use the instances of game feature as globals.
// ignore_for_file: prefer-static-class

// This version of the app is in Italian only.
// ignore_for_file: avoid-non-ascii-symbols

import 'package:flutter/material.dart';

import '/games/battleship.dart';
import '/games/game_area.dart';
import '/games/large_shot.dart';
import '/games/morra.dart';
import '/games/small_shot.dart';
import '/screens/outcome_screen.dart';
import '/screens/turn_play_screen.dart';
import '../games/stopwatch.dart';
import 'config.dart';
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
  final TurnPlayScreen Function() playWidget;
  final OutcomeScreen Function() outcomeWidget;
  final bool lessIsMore;
  final bool longerIsBetter;
  final bool pointsMatter;
  final bool timeMatters;
  final String Function(int) formatPoints;
  final bool usesRigidGameArea;
  final String interstitialAnimationPath; // Path below images with no extension

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
    this.timeMatters = true,
    this.formatPoints = dontFormat,
    this.usesRigidGameArea = false,
    required this.interstitialAnimationPath,
  })  : maxPlayers = maxPlayers ?? Config.maxPlayers,
        maxSuggestedPlayers = maxSuggestedPlayers ?? Config.maxPlayers {
    assert(minPlayers <= minSuggestedPlayers);
    assert(minSuggestedPlayers <= this.maxSuggestedPlayers);
    assert(this.maxSuggestedPlayers <= Config.maxPlayers);
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
  interstitialAnimationPath: "shot/interstitial/Game_Numero Alto",
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
  interstitialAnimationPath: "shot/interstitial/Game_Numero Basso",
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
  // Means the difference between the sum and the guess
  formatPoints: (p) => '±$p',
  interstitialAnimationPath: "morra/interstitial/Morra",
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
  interstitialAnimationPath: "battleship/interstitial/Game_Naval",
);

final stopwatch = GameFeatures(
  name: "Cronometro",
  description: "Spacca il secondo.",
  explanation: """
La lancetta gira velocemente da 0 a 60.

Cerca di fermarla prima che arrivi allo zero, ma più vicino possibile.
  
Guidi tu se la lancetta indica un numero più basso di tutti gli altri.

Ma attenzione: chi finisce col numero più alto, paga.""",
  secretPlay: false,
  icon: Icons.timer_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
  buildGameArea: StopwatchGameArea.new,
  playWidget: Stopwatch.new,
  outcomeWidget: () => StopwatchOutcome(),
  pointsMatter: false,
  timeMatters: false,
  interstitialAnimationPath: "",
);

final List<GameFeatures> allGameFeatures = [
  largeShot,
  smallShot,
  morra,
  battleship,
  stopwatch,
];
