import 'package:flutter/foundation.dart';

import 'player.dart';
import 'team_aware.dart';

mixin TurnAware on TeamAware {
  static List<int> missingTurns = [];
  static Player currentPlayer = NoPlayer();

  Future<bool> nextTurn() async {
    if (missingTurns.isEmpty) {
      currentPlayer = NoPlayer();
      debugPrint("All players have played");
      return false;
    }
    int currentTurn = missingTurns.removeAt(0);
    currentPlayer = players[currentTurn];
    debugPrint("It's ${currentPlayer.name}'s turn");
    return true;
  }

  Future<void> resetTurn() async {
    await retrieveTeam();
    missingTurns = List<int>.generate(players.length, (i) => i);
    missingTurns.shuffle();
    currentPlayer = NoPlayer();
  }
}
