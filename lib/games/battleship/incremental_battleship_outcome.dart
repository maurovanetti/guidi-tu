import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/games/battleship.dart';
import '/games/flame/battleship_board.dart';
import '/games/flame/battleship_replay.dart';

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
  Player? _player;
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
    if (!mounted) return;
    _replay.clear();
    for (var shipSpot in score.recordedMove.move.placedShips().entries) {
      _replay.importShip(shipSpot.key, shipSpot.value);
    }
    setState(() {
      _player = score.recordedMove.player;
    });
    return;
  }

  Future<void> _hit(
    IncrementalBattleshipScore target,
    IncrementalBattleshipScore hitter,
  ) async {
    var shipCellGroups = target.recordedMove.move.placedShipCells();
    for (var cell in hitter.recordedMove.move.placedBombCells()) {
      // bool hit = false;
      for (var shipCellGroup in shipCellGroups) {
        if (shipCellGroup.contains(cell)) {
          // hit = true;
          if (!mounted) return;
          setState(() {
            hitter.pointsForHits += Battleship.hitValue;
          });
        }
      }
      _replay.importBomb(cell);
      var _ = await Future.delayed(const Duration(milliseconds: 200));
      // TODO Animate bomb (hit or !hit)
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
        // TODO Sink animation for shipSpot
        _replay.importSink(shipSpot.value);
        setState(() {
          x.pointsForSaves -= Battleship.saveValue;
        });
      }
    }
    return;
  }

  _buildTableRow(
    String title,
    String Function(IncrementalBattleshipScore) mapper,
  ) {
    var heightFactor = 1.1;
    var style = Theme.of(context).textTheme.headlineMedium;
    return TableRow(children: [
      Center(heightFactor: heightFactor, child: Text(title, style: style)),
      ...widget.incrementalScores.map((x) {
        return Center(child: Text(mapper(x), style: style));
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
                if (widget.incrementalScores.length < 4)
                  _buildTableRow('', (x) => x.recordedMove.player.name)
                else
                  _buildTableRow('', (x) => x.recordedMove.player.icon),
                // ignore: avoid-non-ascii-symbols
                _buildTableRow('🦆', (x) => x.pointsForSaves.toString()),
                // ignore: avoid-non-ascii-symbols
                _buildTableRow('🎯', (x) => "+${x.pointsForHits}"),
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
        bottomChildren: [
          if (_player != null) PlayerTag(_player!),
        ],
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
