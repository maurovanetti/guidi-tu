import 'package:flutter/foundation.dart';

import 'move.dart';
import 'player.dart';
import 'team_aware.dart';

mixin TurnAware<T extends Move> on TeamAware {
  static List<int> _turns = [];

  static List<int> get turns => _turns;

  static int _currentTurn = -1;

  static Player _currentPlayer = NoPlayer();

  static Player get currentPlayer => _currentPlayer;

  static final Map<Player, RecordedMove> _moves = {};

  bool nextTurn() {
    _currentTurn++;
    if (_currentTurn >= turns.length) {
      _currentPlayer = NoPlayer();
      debugPrint("All players have played");

      return false;
    }
    _currentPlayer = players[_turns[_currentTurn]];
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

  void recordMove(T move, double time) {
    _moves[_currentPlayer] = RecordedMove<T>(
      move: move,
      player: _currentPlayer,
      time: time,
    );
  }

  RecordedMove<T> getRecordedMove(Player player) =>
      _moves[player] as RecordedMove<T>;

  T getMove(Player player) => getRecordedMove(player).move;

  int getPoints(Player player) =>
      getMove(player).getPointsFor(player, _moves.values);

  double getTime(Player player) => getRecordedMove(player).time;
}
