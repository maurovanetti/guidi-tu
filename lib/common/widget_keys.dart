import 'package:flutter/foundation.dart';

import 'player.dart';

abstract final class WidgetKeys {
// Outer game widgets
  static const largeShot = Key('large-shot');
  static const smallShot = Key('small-shot');
  static const morra = Key('morra');
  static const battleship = Key('battleship');
  static const stopwatch = Key('stopwatch');
  static const steadyHand = Key('steady-hand');
  static const ouija = Key('ouija');
  static const rps = Key('rps');
  static const straws = Key('straws');
  static const boules = Key('boules');

// Content areas
  static const payer = Key('payer');
  static const driver = Key('driver');

// Team page controls
  static const addPlayer = Key('add-player');
  static const removePlayer = Key('remove-player');
  static const editPlayer = Key('edit-player');
  static const editPlayerName = Key('edit-player-name');
  static const setFemininePlayer = Key('set-feminine-player');
  static const setMasculinePlayer = Key('set-masculine-player');
  static const setNeutralPlayer = Key('set-neutral-player');
  static const cancelEditPlayer = Key('cancel-player');
  static const submitEditPlayer = Key('submit-player');

  // Turn interstitial controls
  static const hiddenPlayAlert = Key('hidden-play');
  static const acknowledgeHiddenPlay = Key('acknowledge-hidden-play');
  static const sensorAlert = Key('sensor');
  static const acknowledgeSensorAlert = Key('acknowledge-sensor');

  // Play page controls
  static const gameArea = Key('game-area');
  static const clock = Key('clock');

  // Language selection
  static const selectEnglish = Key('select-en');
  static const selectItalian = Key('select-it');

  // Navigation buttons
  static const toTutorial = Key('to-tutorial');
  static const toTeam = Key('to-team');
  static const toPick = Key('to-pick');
  static const toTurnInstructions = Key('to-turn-instructions');
  static const toTurnPlay = Key('to-turn-play');
  static const toNextTurn = Key('to-next-turn');
  static const toOutcome = Key('to-outcome');
  static const toPlacement = Key('to-placement');
  static const toHome = Key('to-home');
  static const toChallengeSetup = Key('to-challenge-setup');
  static const toChallenge = Key('to-challenge');
  static const toChallengeScores = Key('to-challenge-scores');

  static Key toInterstitial(String game) => Key('to-interstitial-$game');

  // Recurring widgets
  static Key playerButton(Player player) => Key('player-${player.id}');

  // Pick page controls
  static Key pickGame(String game) => Key('pick-game-$game');
}
