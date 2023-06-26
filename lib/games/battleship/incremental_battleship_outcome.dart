import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/games/battleship.dart';
import 'battleship_board.dart';
import 'battleship_replay.dart';

class IncrementalBattleshipOutcome extends StatefulWidget {
  final List<IncrementalBattleshipScore> incrementalScores;

  const IncrementalBattleshipOutcome({
    super.key,
    required this.incrementalScores,
  });

  @override
  IncrementalBattleshipOutcomeState createState() =>
      IncrementalBattleshipOutcomeState();
}

class IncrementalBattleshipOutcomeState
    extends State<IncrementalBattleshipOutcome> {
  Player _player = Player.none;
  final BattleshipReplay _replay = BattleshipReplay();
  late final GameWidget _gameWidget = GameWidget(game: _replay);

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      for (var x in widget.incrementalScores) {
        await schedule([_setUp(x)], 1.0);
        List<RecordedMove<BattleshipMove>> rivalMoves = [];
        for (var y in widget.incrementalScores) {
          if (x == y) continue;
          await schedule([_hit(x, y)], 0.5);
          rivalMoves.add(y.recordedMove);
        }
        await schedule([_sink(x, rivalMoves)], 3.0);
      }
    });
  }

  Future<void> schedule(Iterable<Future<void>> tasks, double seconds) async {
    if (!mounted) return;
    var _ = await Future.wait(tasks);
    if (!mounted) return;
    return Future.delayed(Duration(
      milliseconds: (Duration.millisecondsPerSecond * seconds).toInt(),
    ));
  }

  Future<void> _setUp(IncrementalBattleshipScore score) async {
    if (mounted) {
      _replay.clear();
      setState(() {
        _player = score.recordedMove.player;
      });
      // ignore: avoid-ignoring-return-values
      await Future.delayed(const Duration(milliseconds: 500));
    } else {
      return;
    }
    for (var shipSpot in score.recordedMove.move.placedShips().entries) {
      // ignore: avoid-ignoring-return-values
      await Future.delayed(const Duration(milliseconds: 200));
      // ignore: avoid-ignoring-return-values
      _replay.importShip(shipSpot.key, shipSpot.value);
    }
    return;
  }

  Future<void> _hit(
    IncrementalBattleshipScore target,
    IncrementalBattleshipScore hitter,
  ) async {
    const missOpacity = 0.3;
    var shipCellGroups = target.recordedMove.move.placedShipCells();
    for (var cell in hitter.recordedMove.move.placedBombCells()) {
      var _ = await Future.delayed(const Duration(milliseconds: 200));
      bool hit = false;
      for (var shipCellGroup in shipCellGroups) {
        if (shipCellGroup.contains(cell)) {
          hit = true;
          if (!mounted) return;
          setState(() {
            hitter.pointsForHits += Battleship.hitValue;
          });
        }
      }
      var bomb = _replay.importBomb(cell, hitter.recordedMove.player);
      bomb.opacity = hit ? 1.0 : missOpacity;
    }
    return;
  }

  _sink(
    IncrementalBattleshipScore x,
    List<RecordedMove<BattleshipMove>> rivalMoves,
  ) async {
    var shipSpots = x.recordedMove.move.placedShips();
    Set<BattleshipBoardCell> rivalBombCells = {};
    for (var rivalMove in rivalMoves) {
      rivalBombCells.addAll(rivalMove.move.placedBombCells());
    }
    for (var shipSpot in shipSpots.entries) {
      if (rivalBombCells.containsAll(shipSpot.key.cells(shipSpot.value))) {
        if (!mounted) return;
        _replay.importSink(shipSpot.value);
        setState(() {
          x.pointsForSaves -= Battleship.saveValue;
        });
      }
    }
    return;
  }

  get _tableStyle => Theme.of(context).textTheme.headlineMedium;

  _buildTableRowFromStrings(
    String title,
    String Function(IncrementalBattleshipScore) mapper,
  ) {
    mapperWrapper(x) => Text(mapper(x), style: _tableStyle);
    return _buildTableRow(title, mapperWrapper);
  }

  _buildTableRow(
    String title,
    Widget Function(IncrementalBattleshipScore) mapper,
  ) {
    var heightFactor = 1.1;
    return TableRow(children: [
      Center(
        heightFactor: heightFactor,
        child: Text(title, style: _tableStyle),
      ),
      ...widget.incrementalScores.map((x) {
        return Center(child: mapper(x));
      }).toList(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SqueezeOrScroll(
        squeeze: true,
        topChildren: [
          Padding(
            padding: StyleGuide.narrowPadding,
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border:
                  TableBorder.all(color: Theme.of(context).colorScheme.primary),
              children: [
                if (widget.incrementalScores.length <= 2)
                  _buildTableRowFromStrings(
                    '',
                    (x) => x.recordedMove.player.name,
                  )
                else
                  _buildTableRow(
                    '',
                    (x) => PlayerIcon.color(x.recordedMove.player),
                  ),
                _buildTableRowFromStrings(
                  // ignore: avoid-non-ascii-symbols
                  '🦆',
                  (x) => x.pointsForSaves.toString(),
                ),
                _buildTableRowFromStrings(
                  // ignore: avoid-non-ascii-symbols
                  '🎯',
                  (x) => "+${x.pointsForHits}",
                ),
              ],
            ),
          ),
          const Text(
            "${Battleship.saveValue} pt. per ogni galleggiante salvato.",
          ),
          const Text(
            "${Battleship.hitValue} pt. per ogni colpo andato a segno.",
          ),
          const Gap(),
        ],
        centralChild: Padding(
          padding: StyleGuide.regularPadding,
          child: AspectRatio(
            aspectRatio: 1.0, // It's a square
            child: _gameWidget,
          ),
        ),
        bottomChildren: [PlayerTag(_player)],
      ),
    );
  }
}

class IncrementalBattleshipScore {
  final RecordedMove<BattleshipMove> recordedMove;
  late int pointsForSaves;
  late int pointsForHits;

  IncrementalBattleshipScore({required this.recordedMove}) {
    pointsForSaves =
        recordedMove.move.placedShips().length * Battleship.saveValue;
    pointsForHits = 0;
  }
}
