import 'package:flutter/foundation.dart';

import 'player.dart';
import 'team_aware.dart';

mixin TurnAware<T extends Move> on TeamAware {
  static List<int> _turns = [];

  static List<int> get turns => _turns;

  static int _currentTurn = -1;

  static Player _currentPlayer = NoPlayer();

  static Player get currentPlayer => _currentPlayer;

  static final Map<Player, Move> _moves = {};

  Future<bool> nextTurn() async {
    _currentTurn++;
    if (_currentTurn >= turns.length) {
      _currentPlayer = NoPlayer();
      debugPrint("All players have played");

      return false;
    }
    _currentPlayer = players[_currentTurn];
    debugPrint("It's ${currentPlayer.name}'s turn");

    return true;
  }

  Future<void> resetTurn() async {
    _moves.clear();
    await retrieveTeam();
    _turns = List<int>.generate(players.length, (i) => i);
    _turns.shuffle();
    _currentTurn = -1;
    _currentPlayer = NoPlayer();
  }

  void recordMove(T move) {
    _moves[_currentPlayer] = move;
  }

  T getMove(Player player) {
    return _moves[player] as T;
  }

  int getPoints(Player player) => getMove(player).getPointsWith(_moves.values);

  double getTime(Player player) => getMove(player).time;
}

abstract class Move {
  final double time;

  Move({required this.time});

  // Override according to the specific game rules
  int getPointsWith(Iterable<Move> allMoves);
}

abstract class MoveWithAttribution extends Move {
  final Player player;

  MoveWithAttribution({required this.player, required double time})
      : super(time: time);

  Iterable<T> otherMoves<T extends MoveWithAttribution>(Iterable<Move> all) =>
      all.cast<T>().where((move) => move.player != player);
}
