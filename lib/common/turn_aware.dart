import 'package:collection/collection.dart';
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

  static final Map<Player, List<RecordedMove>> _moves = {};

  bool nextTurn() {
    _currentTurn++;
    if (_currentTurn >= turns.length) {
      _currentPlayer = Player.none;
      debugPrint("All players have played");

      return false;
    }
    debugPrint("Current turn: $_currentTurn (round $_currentRound)");

    // Rounds after the first one are sorted
    if (_currentTurn >= players.length) {
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

  void sortCurrentRound() {
    final roundEnd = (_currentRound + 1) * players.length;
    final remainingTurnsInRound = _turns.sublist(_currentTurn, roundEnd);
    remainingTurnsInRound.sort((a, b) {
      final moveA = getBestRecordedMove(players[a]);
      final moveB = getBestRecordedMove(players[b]);
      return moveA.compareTo(moveB, _moves.values.flattened);
    });
    _turns.replaceRange(_currentTurn, roundEnd, remainingTurnsInRound);
    debugPrint("Sorted turns: $_turns");
  }

  void recordMove(T move, double time) {
    final recordedMove = RecordedMove<T>(
      move: move,
      player: _currentPlayer,
      time: time,
    );
    if (!_moves.containsKey(_currentPlayer)) {
      _moves[_currentPlayer] = [recordedMove];
    } else {
      _moves[_currentPlayer]!.add(recordedMove);
    }
  }

  List<RecordedMove> getRecordedMoves(Player player) =>
      _moves[player] as List<RecordedMove>;

  RecordedMove<T> getRecordedMove(Player player) {
    return getRecordedMoves(player).single as RecordedMove<T>;
  }

  RecordedMove<T> getBestRecordedMove(Player player) {
    final recordedMoves = getRecordedMoves(player);
    recordedMoves.sort((a, b) => a.samePlayerCompareTo(b));
    return recordedMoves.first as RecordedMove<T>;
  }

  T getBestMove(Player player) => getBestRecordedMove(player).move;

  double getTime(Player player) => getBestRecordedMove(player).time;

  int getPoints(Player player) =>
      getBestMove(player).getPointsFor(player, _moves.values.flattened);
}
