import 'package:flutter/foundation.dart';

import 'move.dart';
import 'player.dart';
import 'team_aware.dart';

mixin TurnAware<T extends Move> on TeamAware {
  static List<int> _turns = [];

  static List<int> get turns => _turns;

  static int _currentTurn = -1;

  int get _currentRound => _currentTurn ~/ players.length;

  static Player _currentPlayer = Player.none;

  static Player get currentPlayer => _currentPlayer;

  static final Map<Player, RecordedMove> _moves = {};

  bool nextTurn() {
    _currentTurn++;
    if (_currentTurn >= turns.length) {
      _currentPlayer = Player.none;
      debugPrint("All players have played");

      return false;
    }

    // Rounds after the first one are sorted
    if (_currentTurn > players.length) {
      sortCurrentRound();
    }

    _currentPlayer = players[_turns[_currentTurn]];
    debugPrint("It's ${currentPlayer.name}'s turn");

    return true;
  }

  Future<void> resetTurn({int rounds = 1}) async {
    _moves.clear();
    await retrieveTeam();
    _turns = List<int>.generate(players.length, (i) => i);
    // Shuffles the first round
    _turns.shuffle();
    for (var round = 1; round < rounds; round++) {
      // Adds the next rounds (with the same order, initially)
      _turns.addAll(_turns.sublist(0, players.length));
    }
    _currentTurn = -1;
    _currentPlayer = Player.none;
  }

  bool get worstFirst => true;

  Future<void> sortCurrentRound() async {
    final roundEnd = (_currentRound + 1) * players.length;
    final remainingTurnsInRound = _turns.sublist(_currentTurn, roundEnd);
    remainingTurnsInRound.sort((a, b) {
      final moveA = getRecordedMove(players[a]);
      final moveB = getRecordedMove(players[b]);
      return moveA.compareTo(moveB, _moves.values);
    });
    _turns.replaceRange(_currentTurn, roundEnd, remainingTurnsInRound);
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
