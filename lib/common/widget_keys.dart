import 'package:flutter/foundation.dart';

import 'player.dart';

// Outer game widgets
const largeShotWidgetKey = Key('large-shot');
const smallShotWidgetKey = Key('small-shot');
const morraWidgetKey = Key('morra');
const battleshipWidgetKey = Key('battleship');

// Content areas
const payerWidgetKey = Key('payer');
const driverWidgetKey = Key('driver');

// Recurring widgets
Key playerButtonWidgetKey(Player player) => Key('player-${player.id}');

// Navigation buttons
const toTutorialWidgetKey = Key('to-tutorial');
const toTeamWidgetKey = Key('to-team');
const toPickWidgetKey = Key('to-pick');
const toTurnInterstitialWidgetKey = Key('to-turn-interstitial');
const toTurnPlayWidgetKey = Key('to-turn-play');
const toNextTurnWidgetKey = Key('to-next-turn');
const toOutcomeWidgetKey = Key('to-outcome');
const toPlacementWidgetKey = Key('to-placement');
const toHomeWidgetKey = Key('to-home');

// Team page controls
const addPlayerWidgetKey = Key('add-player');
const removePlayerWidgetKey = Key('remove-player');
const editPlayerWidgetKey = Key('edit-player');
const editPlayerNameWidgetKey = Key('edit-player-name');
const setFemininePlayerWidgetKey = Key('set-feminine-player');
const setMasculinePlayerWidgetKey = Key('set-masculine-player');
const cancelEditPlayerWidgetKey = Key('cancel-player');
const submitEditPlayerWidgetKey = Key('submit-player');

// Pick page controls
Key pickGameWidgetKey(String game) => Key('pick-game-$game');

// Turn interstitial controls
const hiddenPlayAlertWidgetKey = Key('hidden-play');
const acknowledgeHiddenPlayWidgetKey = Key('acknowledge-hidden-play');

// Play page controls
const gameAreaWidgetKey = Key('game-area');
const clockWidgetKey = Key('clock');
