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

  static final _moves = <Player, List<RecordedMove>>{};

  bool tryNextTurn() {
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

  void resetTurn({int rounds = 1}) {
    _moves.clear();
    retrieveTeam();
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

  void sortCurrentRound() {
    final roundEnd = (_currentRound + 1) * players.length;
    final remainingTurnsInRound = _turns.sublist(_currentTurn, roundEnd);
    remainingTurnsInRound.sort((a, b) {
      final moveA = getBestRecordedMove(players[a]);
      final moveB = getBestRecordedMove(players[b]);
      // ignore: avoid-slow-collection-methods
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
    if (_moves.containsKey(_currentPlayer)) {
      _moves[_currentPlayer]!.add(recordedMove);
    } else {
      _moves[_currentPlayer] = [recordedMove];
    }
  }

  /// New moves are ignored (use [recordMove] for it).
  void updateOldMoves(Player player, List<T> moves) {
    var oldPlayerMoves = _moves[player];
    if (oldPlayerMoves != null) {
      for (int i = 0; i < moves.length && i < oldPlayerMoves.length; i++) {
        var recordedMove = _moves[player]?[i];
        if (recordedMove != null) {
          _moves[player]?[i] = RecordedMove(
            player: player,
            time: recordedMove.time,
            move: moves[i],
          );
        }
      }
    }
  }

  List<RecordedMove> getRecordedMoves(Player player) =>
      _moves[player] as List<RecordedMove>;

  RecordedMove<T> getRecordedMove(Player player) {
    // ignore: avoid-inferrable-type-arguments
    return getRecordedMoves(player).single.castContentAs<T>();
  }

  RecordedMove<T> getBestRecordedMove(Player player) {
    final recordedMoves = getRecordedMoves(player);
    recordedMoves.sort((a, b) => a.samePlayerCompareTo(b));
    // ignore: avoid-inferrable-type-arguments
    return recordedMoves.first.castContentAs<T>();
  }

  T getBestMove(Player player) => getBestRecordedMove(player).move;

  double getTime(Player player) => getBestRecordedMove(player).time;

  int getPoints(Player player) =>
      // ignore: avoid-slow-collection-methods
      getBestMove(player).getPointsFor(player, _moves.values.flattened);
}
