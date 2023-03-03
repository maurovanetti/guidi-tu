import '/common/player.dart';

abstract class Move {
  // Override according to the specific game rules
  int getPointsFor(Player player, Iterable<RecordedMove> allMoves);
}

class NoMove extends Move {
  @override
  int getPointsFor(player, allMoves) => 0;
}

class RecordedMove<T extends Move> {
  final Player player;
  final double time;
  final T move;

  RecordedMove({
    required this.player,
    required this.time,
    required this.move,
  });

  static Iterable<RecordedMove> otherMoves(
    Player player,
    Iterable<RecordedMove> all,
  ) =>
      all.cast<RecordedMove>().where((move) => move.player != player);
}

mixin MoveReceiver<T extends Move> {
  MoveProvider<T>? moveProvider;

  T receiveMove() => moveProvider!.getMove();
}

mixin MoveProvider<T extends Move> {
  T getMove();

  void addReceiver(MoveReceiver<T> receiver) {
    receiver.moveProvider = this;
  }
}
