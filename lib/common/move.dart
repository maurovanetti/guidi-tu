import 'player.dart';

abstract class Move {
  const Move();

  // Override according to the specific game rules
  int getPointsFor(Player player, Iterable<RecordedMove> allMoves);
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
