// We want to use the instances of game feature as globals.
// ignore_for_file: prefer-static-class

// This version of the app is in Italian only.
// ignore_for_file: avoid-non-ascii-symbols

import 'package:flutter/material.dart';

import '/games/battleship.dart';
import '/games/boules.dart';
import '/games/game_area.dart';
import '/games/large_shot.dart';
import '/games/morra.dart';
import '/games/ouija.dart';
import '/games/rps.dart';
import '/games/small_shot.dart';
import '/games/steady_hand.dart';
import '/games/stopwatch.dart';
import '/games/straws.dart';
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
  final int rounds;
  final GameArea Function({
    required void Function(bool ready) setReady,
    required MoveReceiver moveReceiver,
    required DateTime startTime,
  }) buildGameArea;
  final TurnPlayScreen Function() playWidget;
  final OutcomeScreen Function() outcomeWidget;
  final bool lessIsMore;
  final bool longerIsBetter;
  final bool pointsMatter;
  final bool externalClock;
  final String Function(int points) formatPoints;
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
    this.rounds = 1,
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

  static String dontFormat(int i) => i.toString();
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
La lancetta gira velocemente. Puoi fermarla quando vuoi.

Se supera il mezzogiorno, ricomincia da zero.

Guidi tu se hai fermato la lancetta al valore più basso.

Ma attenzione: chi la ferma più avanti di tutti, paga.""",
  secretPlay: true,
  icon: Icons.timer_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
  buildGameArea: StopwatchGameArea.new,
  playWidget: Stopwatch.new,
  outcomeWidget: StopwatchOutcome.new,
  formatPoints: (p) =>
      '${I18n.preciserSecondsFormat.format(p / Duration.microsecondsPerSecond)}"',
  externalClock: false,
  interstitialAnimationPath: "stopwatch/interstitial/Game_Lancette",
);

final steadyHand = GameFeatures(
  name: "Mano ferma",
  description: "Resisti immobile.",
  explanation: """
Tieni il telefono in orizzontale sulla tua mano.
  
Non far cadere la biglia.
  
Guidi tu se resisti meno di tutti.

Ma attenzione: chi resiste più a lungo, paga.""",
  secretPlay: true,
  icon: Icons.sports_gymnastics_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
  buildGameArea: SteadyHandGameArea.new,
  playWidget: SteadyHand.new,
  outcomeWidget: SteadyHandOutcome.new,
  formatPoints: (p) =>
      '${I18n.secondsFormat.format(p / Duration.microsecondsPerSecond)}"',
  externalClock: false,
  usesRigidGameArea: true,
  interstitialAnimationPath: "steady_hand/interstitial/Steady_Hand",
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
  secretPlay: true,
  icon: Icons.transcribe_rounded,
  minPlayers: 3,
  minSuggestedPlayers: 4,
  buildGameArea: OuijaGameArea.new,
  playWidget: Ouija.new,
  outcomeWidget: OuijaOutcome.new,
  formatPoints: (p) => '$p pt.',
  usesRigidGameArea: true,
  interstitialAnimationPath: "ouija/interstitial/Telepathy",
);

final rps = GameFeatures(
  name: "Morra cinese",
  description: "Sasso, carta o forbici?",
  explanation: """
Componi una sequenza di gesti.

Ogni gesto che vince ti fa fare un punto.
  
Guida chi fa meno punti.

Ma attenzione: chi ne fa di più, paga.""",
  secretPlay: true,
  icon: Icons.cut_rounded,
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

final straws = GameFeatures(
  name: "Bastoncino corto",
  description: "Scegli un bastoncino.",
  explanation: """
Puoi cambiare bastoncino finché non ne trovi uno che ti piace. 
  
Guidi tu se lo scegli più corto degli altri.

Ma attenzione: chi sceglie il più lungo, paga.""",
  secretPlay: true,
  icon: Icons.equalizer_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
  buildGameArea: StrawsGameArea.new,
  playWidget: Straws.new,
  outcomeWidget: StrawsOutcome.new,
  formatPoints: (p) => '${I18n.centimetersFormat.format(p.toDouble() / 10)} cm',
  usesRigidGameArea: true,
  interstitialAnimationPath: "straws/interstitial/Game_Straws",
);

final boules = GameFeatures(
  name: "Bocce",
  description: "Avvicinati al boccino.",
  explanation: """
Due bocce a testa, conta solo il tiro migliore.
Scegli la posizione di partenza, la direzione e la forza dei lanci. 
  
Guidi tu se alla fine la boccia più lontana dal boccino bianco è la tua.

Ma attenzione: chi avrà la boccia più vicina al boccino, paga.""",
  secretPlay: false,
  icon: Icons.sports_baseball_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
  rounds: 2,
  buildGameArea: BoulesGameArea.new,
  playWidget: Boules.new,
  outcomeWidget: BoulesOutcome.new,
  formatPoints: (p) => '${I18n.centimetersFormat.format(p.toDouble() / 10)} cm',
  lessIsMore: true,
  usesRigidGameArea: true,
  externalClock: false,
  interstitialAnimationPath: "",
);

final allGameFeatures = [
  largeShot,
  smallShot,
  morra,
  battleship,
  stopwatch,
  steadyHand,
  ouija,
  rps,
  straws,
  boules,
];
