import 'package:flutter/foundation.dart';

import 'player.dart';
import 'team_aware.dart';

mixin TurnAware<T extends Move> on TeamAware {
  static List<int> turns = [];
  static int currentTurn = -1;
  static Player currentPlayer = NoPlayer();
  static Map<Player, Move> moves = {};

  Future<bool> nextTurn() async {
    currentTurn++;
    if (currentTurn >= turns.length) {
      currentPlayer = NoPlayer();
      debugPrint("All players have played");
      return false;
    }
    currentPlayer = players[currentTurn];
    debugPrint("It's ${currentPlayer.name}'s turn");
    return true;
  }

  Future<void> resetTurn() async {
    moves.clear();
    await retrieveTeam();
    turns = List<int>.generate(players.length, (i) => i);
    turns.shuffle();
    currentTurn = -1;
    currentPlayer = NoPlayer();
  }

  void recordMove(T move) {
    moves[currentPlayer] = move;
  }

  T getMove(Player player) {
    return moves[player] as T;
  }

  int getPoints(Player player) => getMove(player).getPointsWith(moves.values);

  double getTime(Player player) => getMove(player).time;
}

abstract class Move {
  final double time;

  Move({required this.time});

  // Override according to the specific game rules
  int getPointsWith(Iterable<Move> allMoves);
}
