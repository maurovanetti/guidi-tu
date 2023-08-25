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

  // This is used to sort the turns in games with multiple rounds.
  int compareTo(RecordedMove<T> other, Iterable<RecordedMove> all) {
    final thisPriority = move.getTurnPriorityFor(player, all);
    final otherPriority = other.move.getTurnPriorityFor(other.player, all);
    return thisPriority - otherPriority;
  }
}

mixin MoveReceiver<T extends Move> {
  MoveProvider<T>? moveProvider;

  T receiveMove() => moveProvider!.getMove();
}

mixin MoveProvider<T extends Move> {
  T getMove();

  void addReceiver(MoveReceiver<T> receiver) {
    // ignore: avoid-mutating-parameters
    receiver.moveProvider = this;
  }
}
