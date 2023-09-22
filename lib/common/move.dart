import 'package:flutter/foundation.dart';

import 'player.dart';

abstract class Move {
  const Move();

  // Override according to the specific game rules.
  int getPointsFor(Player player, Iterable<RecordedMove> allMoves);

  // This is only relevant for games with multiple rounds. The first round is
  // always random because there are no previous moves to base the decision on.
  // Override according to the specific game rules.
  int getTurnPriorityFor(Player player, Iterable<RecordedMove> allMoves) =>
      getPointsFor(player, allMoves);

  // Override for games with multiple rounds.
  @protected
  int samePlayerCompareTo(Move other) => 0;
}

class NoMove extends Move {
  const NoMove();

  @override
  int getPointsFor(Player player, Iterable<RecordedMove> allMoves) => 0;
}

class RecordedMove<T extends Move> {
  final Player player;
  final double time;
  final T move;

  const RecordedMove({
    required this.player,
    required this.time,
    required this.move,
  });

  static Iterable<RecordedMove> otherMoves(
    Player thisPlayer,
    Iterable<RecordedMove> all,
  ) =>
      all
          .cast<RecordedMove>()
          .where((thisMove) => thisMove.player != thisPlayer);

  RecordedMove<U> castContentAs<U extends Move>() {
    return RecordedMove<U>(player: player, time: time, move: move as U);
  }

  // This is used to sort the turns in games with multiple rounds.
  int compareTo(RecordedMove<T> other, Iterable<RecordedMove> all) {
    final thisPriority = move.getTurnPriorityFor(player, all);
    final otherPriority = other.move.getTurnPriorityFor(other.player, all);
    return thisPriority - otherPriority;
  }

  int samePlayerCompareTo(RecordedMove other) {
    assert(player == other.player, "This method is only for same-player moves");
    int comparison = move.samePlayerCompareTo(other.move);
    return comparison == 0 ? -time.compareTo(other.time) : comparison;
  }
}

mixin MoveReceiver<T extends Move> {
  MoveProvider<T>? moveProvider;

  //T receiveMove() => moveProvider!.getMoveUpdate().newMove;

  MoveUpdate<T> receiveMoves() => moveProvider!.getMoveUpdate();
}

typedef MoveUpdate<T extends Move> = ({
  T newMove,
  Map<Player, List<T>> updatedOldMoves,
});

mixin MoveProvider<T extends Move> {
  MoveUpdate<T> getMoveUpdate();

  void addReceiver(MoveReceiver<T> receiver) {
    // ignore: avoid-mutating-parameters
    receiver.moveProvider = this;
  }
}
