// We want to use the instances of game feature as globals.
// ignore_for_file: prefer-static-class

// This version of the app is in Italian only.
// ignore_for_file: avoid-non-ascii-symbols

import 'package:flutter/material.dart';

import '/games/battleship.dart';
import '/games/boules.dart';
import '/games/large_shot.dart';
import '/games/morra.dart';
import '/games/ouija.dart';
import '/games/rps.dart';
import '/games/small_shot.dart';
import '/games/steady_hand.dart';
import '/games/stopwatch.dart';
import '/games/straws.dart';
import 'common.dart';

class GameFeatures {
  final String id;
  final LocalizedString name;
  final LocalizedString description;
  final LocalizedString explanation;
  final bool secretPlay;
  final IconData icon;
  final int minPlayers;
  final int maxPlayers;
  final int minSuggestedPlayers;
  final int maxSuggestedPlayers;
  final int rounds;
  final GameAreaBuilder onBuildGameArea;
  final TurnPlayScreenBuilder onBuildTurnPlayScreen;
  final OutcomeScreenBuilder onBuildOutcomeScreen;
  final bool lessIsMore;
  final bool longerIsBetter;
  final bool pointsMatter;
  final bool externalClock;
  final ScoreFormatter onFormatPoints;
  final bool usesRigidGameArea;
  final String interstitialAnimationPath; // Path below images with no extension
  final num interstitialAnimationRepeat;
  final bool mobileOnly;

  GameFeatures({
    required this.id,
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
    required this.onBuildTurnPlayScreen,
    required this.onBuildGameArea,
    required this.onBuildOutcomeScreen,
    this.lessIsMore = false,
    this.longerIsBetter = false,
    this.pointsMatter = true,
    this.externalClock = true,
    this.onFormatPoints = dontFormat,
    this.usesRigidGameArea = false,
    required this.interstitialAnimationPath,
    this.interstitialAnimationRepeat = 1,
    this.mobileOnly = false,
  })  : maxPlayers = maxPlayers ?? Config.maxPlayers,
        maxSuggestedPlayers = maxSuggestedPlayers ?? Config.maxPlayers {
    assert(minPlayers <= minSuggestedPlayers);
    assert(minSuggestedPlayers <= this.maxSuggestedPlayers);
    assert(this.maxSuggestedPlayers <= Config.maxPlayers);
  }

  static String dontFormat(int i, _) => i.toString();
}

final largeShot = GameFeatures(
  id: "ls",
  name: ($) => $.longShotName,
  description: ($) => $.longShotDescription,
  explanation: ($) => $.longShotExplanation,
  secretPlay: true,
  icon: Icons.arrow_circle_up_rounded,
  minPlayers: 3,
  minSuggestedPlayers: 5,
  onBuildGameArea: LargeShotGameArea.new,
  onBuildTurnPlayScreen: LargeShot.new,
  onBuildOutcomeScreen: LargeShotOutcome.new,
  interstitialAnimationPath: "shot/interstitial/Game_Numero Alto",
);

final smallShot = GameFeatures(
  id: "ss",
  name: ($) => $.shortShotName,
  description: ($) => $.shortShotDescription,
  explanation: ($) => $.shortShotExplanation,
  secretPlay: true,
  icon: Icons.arrow_circle_down_rounded,
  minPlayers: 3,
  minSuggestedPlayers: 5,
  onBuildGameArea: SmallShotGameArea.new,
  onBuildTurnPlayScreen: SmallShot.new,
  onBuildOutcomeScreen: SmallShotOutcome.new,
  lessIsMore: true,
  interstitialAnimationPath: "shot/interstitial/Game_Numero Basso",
);

final morra = GameFeatures(
  id: "m5",
  name: ($) => $.morraName,
  description: ($) => $.morraDescription,
  explanation: ($) => $.morraExplanation,
  secretPlay: true,
  icon: Icons.back_hand_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 3,
  maxSuggestedPlayers: 3,
  onBuildGameArea: MorraGameArea.new,
  onBuildTurnPlayScreen: Morra.new,
  onBuildOutcomeScreen: MorraOutcome.new,
  lessIsMore: true,
  // Means the difference between the sum and the guess
  onFormatPoints: (p, $) => $.plusMinusN(p),
  interstitialAnimationPath: "morra/interstitial/Morra",
  interstitialAnimationRepeat: 2,
);

final battleship = GameFeatures(
  id: "bs",
  name: ($) => $.battleshipName,
  description: ($) => $.battleshipDescription,
  explanation: ($) => $.battleshipExplanation(
    Battleship.saveValue,
    Battleship.hitValue,
  ),
  secretPlay: true,
  icon: Icons.sailing_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
  maxSuggestedPlayers: 4,
  onBuildGameArea: BattleshipGameArea.new,
  onBuildTurnPlayScreen: Battleship.new,
  onBuildOutcomeScreen: BattleshipOutcome.new,
  onFormatPoints: (p, $) => $.nPoints(p),
  usesRigidGameArea: true,
  interstitialAnimationPath: "battleship/interstitial/Game_Naval",
);

final stopwatch = GameFeatures(
  id: "sw",
  name: ($) => $.stopwatchName,
  description: ($) => $.stopwatchDescription,
  explanation: ($) => $.stopwatchExplanation,
  secretPlay: true,
  icon: Icons.timer_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 4,
  onBuildGameArea: StopwatchGameArea.new,
  onBuildTurnPlayScreen: Stopwatch.new,
  onBuildOutcomeScreen: StopwatchOutcome.new,
  onFormatPoints: (p, $) =>
      $.xSecondsPrecise(p / Duration.microsecondsPerSecond),
  externalClock: false,
  interstitialAnimationPath: "stopwatch/interstitial/Game_Lancette",
);

final steadyHand = GameFeatures(
  id: "sh",
  name: ($) => $.steadyHandName,
  description: ($) => $.steadyHandDescription,
  explanation: ($) => $.steadyHandExplanation,
  secretPlay: true,
  icon: Icons.sports_gymnastics_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 3,
  onBuildGameArea: SteadyHandGameArea.new,
  onBuildTurnPlayScreen: SteadyHand.new,
  onBuildOutcomeScreen: SteadyHandOutcome.new,
  onFormatPoints: (p, $) => $.xSeconds(p / Duration.microsecondsPerSecond),
  externalClock: false,
  usesRigidGameArea: true,
  mobileOnly: true,
  interstitialAnimationPath: "steady_hand/interstitial/Steady_Hand",
);

final ouija = GameFeatures(
  id: "oj",
  name: ($) => $.ouijaName,
  description: ($) => $.ouijaDescription,
  explanation: ($) => $.ouijaExplanation(
    Ouija.missValue,
    Ouija.guessValue,
  ),
  secretPlay: true,
  icon: Icons.transcribe_rounded,
  minPlayers: 3,
  minSuggestedPlayers: 5,
  onBuildGameArea: OuijaGameArea.new,
  onBuildTurnPlayScreen: Ouija.new,
  onBuildOutcomeScreen: OuijaOutcome.new,
  onFormatPoints: (p, $) => $.nPoints(p),
  usesRigidGameArea: true,
  interstitialAnimationPath: "ouija/interstitial/Telepathy",
);

final rps = GameFeatures(
  id: "m3",
  name: ($) => $.rpsName,
  description: ($) => $.rpsDescription,
  explanation: ($) => $.rpsExplanation,
  secretPlay: true,
  icon: Icons.cut_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
  maxSuggestedPlayers: 2,
  onBuildGameArea: RockPaperScissorsGameArea.new,
  onBuildTurnPlayScreen: RockPaperScissors.new,
  onBuildOutcomeScreen: RockPaperScissorsOutcome.new,
  onFormatPoints: (p, $) => $.nPoints(p),
  usesRigidGameArea: true,
  interstitialAnimationPath: "rps/interstitial/Morra",
);

final straws = GameFeatures(
  id: "st",
  name: ($) => $.strawsName,
  description: ($) => $.strawsDescription,
  explanation: ($) => $.strawsExplanation,
  secretPlay: true,
  icon: Icons.equalizer_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 4,
  onBuildGameArea: StrawsGameArea.new,
  onBuildTurnPlayScreen: Straws.new,
  onBuildOutcomeScreen: StrawsOutcome.new,
  onFormatPoints: (p, $) => $.xCentimeters(p.toDouble() / 10),
  usesRigidGameArea: true,
  interstitialAnimationPath: "straws/interstitial/Game_Straws",
);

final boules = GameFeatures(
  id: "bo",
  name: ($) => $.boulesName,
  description: ($) => $.boulesDescription,
  explanation: ($) => $.boulesExplanation,
  icon: Icons.sports_baseball_rounded,
  minPlayers: 2,
  minSuggestedPlayers: 2,
  rounds: 2,
  onBuildGameArea: BoulesGameArea.new,
  onBuildTurnPlayScreen: Boules.new,
  onBuildOutcomeScreen: BoulesOutcome.new,
  onFormatPoints: (p, $) => $.xCentimeters(p.toDouble() / 10),
  lessIsMore: true,
  usesRigidGameArea: true,
  externalClock: false,
  interstitialAnimationPath: "boules/interstitial/Game_Bocce",
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
