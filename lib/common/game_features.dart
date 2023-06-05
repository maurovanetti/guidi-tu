// We want to use the instances of game feature as globals.
// ignore_for_file: prefer-static-class

// This version of the app is in Italian only.
// ignore_for_file: avoid-non-ascii-symbols

import 'package:flutter/material.dart';

import '/games/battleship.dart';
import '/games/game_area.dart';
import '/games/large_shot.dart';
import '/games/morra.dart';
import '/games/ouija.dart';
import '/games/rps.dart';
import '/games/small_shot.dart';
import '/games/steady_hand.dart';
import '/games/stopwatch.dart';
import '/screens/outcome_screen.dart';
import '/screens/turn_play_screen.dart';
import 'config.dart';
import 'i18n.dart';
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
    required DateTime startTime,
  }) buildGameArea;
  final TurnPlayScreen Function() playWidget;
  final OutcomeScreen Function() outcomeWidget;
  final bool lessIsMore;
  final bool longerIsBetter;
  final bool pointsMatter;
  final bool externalClock;
  final String Function(int) formatPoints;
  final bool usesRigidGameArea;
  final String interstitialAnimationPath; // Path below images with no extension
  final num interstitialAnimationRepeat;

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
    this.externalClock = true,
    this.formatPoints = dontFormat,
    this.usesRigidGameArea = false,
    required this.interstitialAnimationPath,
    this.interstitialAnimationRepeat = 1,
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
  outcomeWidget: LargeShotOutcome.new,
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
  outcomeWidget: SmallShotOutcome.new,
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
  interstitialAnimationRepeat: 2,
);

final battleship = GameFeatures(
  name: "Battaglia navale",
  description: "Salva e affonda.",
  explanation: """
Scegli dove collocare i tuoi galleggianti e in quali caselle attaccare.

Fai ${Battleship.saveValue} punti per ogni tuo galleggiante salvato, ${Battleship.hitValue} per ognuno che affondi. 
  
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
La lancetta gira velocemente.

Cerca di fermarla prima che arrivi allo zero, ma più vicino possibile.
  
Guidi tu se hai fermato la lancetta più indietro di tutti.

Ma attenzione: chi la ferma più avanti di tutti, paga.""",
  secretPlay: false,
  icon: Icons.timer_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
  buildGameArea: StopwatchGameArea.new,
  playWidget: Stopwatch.new,
  outcomeWidget: StopwatchOutcome.new,
  formatPoints: (p) =>
      '${I18n.preciserSecondsFormat.format(p / Duration.microsecondsPerSecond)}"',
  externalClock: false,
  interstitialAnimationPath: "",
);

final steadyHand = GameFeatures(
  name: "Mano ferma",
  description: "Resisti immobile.",
  explanation: """
Tieni il telefono in orizzontale sulla tua mano.
  
Comparirà una biglia, appoggiata sullo schermo.

Non farla cadere dalla piattaforma circolare per il tempo più lungo possibile.
  
Guidi tu se resisti meno di tutti.

Ma attenzione: chi resiste più a lungo, paga.""",
  icon: Icons.balance_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
  buildGameArea: SteadyHandGameArea.new,
  playWidget: SteadyHand.new,
  outcomeWidget: SteadyHandOutcome.new,
  formatPoints: (p) =>
      '${I18n.secondsFormat.format(p / Duration.microsecondsPerSecond)}"',
  externalClock: false,
  usesRigidGameArea: true,
  interstitialAnimationPath: "",
);

final ouija = GameFeatures(
  name: "Telepatia",
  description: "Indovina la parola.",
  explanation: """
Componi una sequenza di lettere.

Fai ${Ouija.missValue} pt. per ogni lettera usata anche da altri, 
${Ouija.guessValue} pt. se è anche nella stessa posizione. 
  
Guida chi fa meno punti.

Ma attenzione: chi ne fa di più, paga.""",
  icon: Icons.wifi_rounded,
  minPlayers: 3,
  minSuggestedPlayers: 4,
  buildGameArea: OuijaGameArea.new,
  playWidget: Ouija.new,
  outcomeWidget: OuijaOutcome.new,
  formatPoints: (p) => '$p pt.',
  usesRigidGameArea: true,
  interstitialAnimationPath: "",
);

final rps = GameFeatures(
  name: "Morra cinese",
  description: "Sasso, carta o forbici?",
  explanation: """
Componi una sequenza di giocate. 
Sasso batte forbici, forbici battono carta, carta batte sasso.

Per ogni turno, se non c'è un pareggio, una fazione vince e l'altra perde.
Chi vince fa 1 punto.
  
Guida chi fa meno punti.

Ma attenzione: chi ne fa di più, paga.""",
  icon: Icons.recycling_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
  maxSuggestedPlayers: 3,
  buildGameArea: RockPaperScissorsGameArea.new,
  playWidget: RockPaperScissors.new,
  outcomeWidget: RockPaperScissorsOutcome.new,
  formatPoints: (p) => '$p pt.',
  usesRigidGameArea: true,
  interstitialAnimationPath: "rps/interstitial/Morra",
);

final List<GameFeatures> allGameFeatures = [
  largeShot,
  smallShot,
  morra,
  battleship,
  stopwatch,
  steadyHand,
  ouija,
  rps,
];
