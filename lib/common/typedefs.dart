import 'dart:async';

import 'package:guidi_tu/common/common.dart';

import '/games/game_area.dart';
import '/screens/outcome_screen.dart';
import '/screens/pick_screen.dart';
import '/screens/turn_play_screen.dart';

typedef OnChangeReady = void Function({bool ready});
typedef OnMessage = void Function(String message);
typedef OnScore = void Function(int score);
typedef ScoreFormatter = String Function(int score, AppLocalizations $);
typedef AsyncCallback = FutureOr<void> Function()?;
typedef BoolCallback = bool Function();
typedef GameAreaBuilder = GameArea Function({
  required OnChangeReady onChangeReady,
  required MoveReceiver moveReceiver,
  required DateTime startTime,
});
typedef TurnPlayScreenBuilder = TurnPlayScreen Function();
typedef OutcomeScreenBuilder = OutcomeScreen Function();
typedef OnPlayerAction = void Function(Player player);
typedef OnSetInteger = void Function(int value);
typedef OnSelectGameCard = FutureOr<void> Function(GameCard card);
