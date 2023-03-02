import '/common/player.dart';

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
