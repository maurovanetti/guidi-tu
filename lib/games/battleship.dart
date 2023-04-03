import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/screens/outcome_screen.dart';
import '/screens/turn_play_screen.dart';
import 'flame/battleship_module.dart';
import 'flame/battleship_replay.dart';
import 'game_area.dart';

class Battleship extends TurnPlayScreen {
  static const saveValue = 5; // points for each own ship saved from enemy hits
  static const hitValue = 1; // points for each hit falling on an enemy ship

  @override
  final bool isReadyAtStart = false;

  Battleship() : super(key: WidgetKeys.battleship, gameFeatures: battleship);

  @override
  createState() => TurnPlayState<BattleshipMove>();
}

class BattleshipGameArea extends GameArea<BattleshipMove> {
  BattleshipGameArea({
    super.key,
    required super.setReady,
    required MoveReceiver moveReceiver,
    required super.startTime,
  }) : super(
          gameFeatures: morra,
          moveReceiver: moveReceiver as MoveReceiver<BattleshipMove>,
        );

  @override
  createState() => BattleshipGameAreaState();
}

class BattleshipGameAreaState extends GameAreaState<BattleshipMove> {
  late final BattleshipModule _gameModule;

  @override
  void initState() {
    _gameModule = BattleshipModule(setReady: widget.setReady);
    super.initState();
  }

  @override
  BattleshipMove getMove() => BattleshipMove(
        placedItems: _gameModule.board.placedItems,
      );

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: _gameModule);
  }
}

class BattleshipOutcome extends OutcomeScreen {
  BattleshipOutcome({super.key}) : super(gameFeatures: battleship);

  @override
  BattleshipOutcomeState createState() => BattleshipOutcomeState();
}

class BattleshipOutcomeState extends OutcomeScreenState<BattleshipMove> {
  List<IncrementalBattleshipScore> incrementalScores = [];

  @override
  initState() {
    super.initState();
    for (var playerIndex in TurnAware.turns) {
      var player = players[playerIndex];
      var recordedMove = getRecordedMove(player);
      incrementalScores.add(IncrementalBattleshipScore(
        recordedMove: recordedMove,
      ));
    }
  }

  @override
  void initOutcome() {
    repeatable = true;
    outcomeWidget =
        IncrementalBattleshipOutcome(incrementalScores: incrementalScores);
  }
}

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
  final GameWidget _gameWidget = GameWidget(game: BattleshipReplay());

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      for (var x in widget.incrementalScores) {
        await schedule([_setUp(x)], 3.0);
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
    hitter.recordedMove.move.placedBombCells().forEach((cell) {
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
      // TODO Common animation data
      if (hit) {
        // TODO Hit animation
      } else {
        // TODO Miss animation
      }
    });
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
    var heightFactor = 1.5;
    return TableRow(children: [
      Center(heightFactor: heightFactor, child: Text(title)),
      ...widget.incrementalScores.map((x) {
        var value = mapper(x);
        return Center(child: Text(value));
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
                _buildTableRow('🎯', (x) => x.pointsForHits.toString()),
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

class BattleshipMove extends Move {
  final Map<BattleshipItem, BattleshipBoardCell> placedItems;

  BattleshipMove({
    required this.placedItems,
  });

  // Not using a getter here to indicate that the computation is expensive
  Map<BattleshipShip, BattleshipBoardCell> placedShips() {
    Map<BattleshipShip, BattleshipBoardCell> ps = {};
    for (var entry
        in placedItems.entries.where((e) => e.key is BattleshipShip)) {
      ps[entry.key as BattleshipShip] = entry.value;
    }
    return ps;
  }

  // Every ship may have several distinct cells
  List<Set<BattleshipBoardCell>> placedShipCells() {
    List<Set<BattleshipBoardCell>> cells = [];
    for (var entry in placedShips().entries) {
      cells.add(entry.key.cells(entry.value));
    }
    return cells;
  }

  // Not using a getter here to indicate that the computation is expensive
  Map<BattleshipBomb, BattleshipBoardCell> placedBombs() {
    Map<BattleshipBomb, BattleshipBoardCell> pb = {};
    for (var entry
        in placedItems.entries.where((e) => e.key is BattleshipBomb)) {
      pb[entry.key as BattleshipBomb] = entry.value;
    }
    return pb;
  }

  // Every bomb has a distinct cell
  Set<BattleshipBoardCell> placedBombCells() {
    return Set.of(placedBombs().values);
  }

  @override
  int getPointsFor(Player player, Iterable<RecordedMove> allMoves) {
    var rivalMoves = RecordedMove.otherMoves(player, allMoves)
        .cast<RecordedMove<BattleshipMove>>();
    return _getSavePointsFor(player, rivalMoves) +
        _getHitPointsFor(player, rivalMoves);
  }

  int _getSavePointsFor(
    Player player,
    Iterable<RecordedMove<BattleshipMove>> rivalMoves,
  ) {
    var ownShips = placedItems.keys.whereType<BattleshipShip>().toList();
    Set<BattleshipBoardCell> rivalBombCells = {};
    for (var rivalMove in rivalMoves) {
      rivalBombCells.addAll(rivalMove.move.placedBombCells());
    }

    // Rival bombs hitting own ships
    int sunkenShipsCount = 0;
    for (var ownShip in ownShips) {
      var ownShipCells = ownShip.cells(placedItems[ownShip]!);
      if (rivalBombCells.containsAll(ownShipCells)) {
        sunkenShipsCount++;
      }
    }
    int sparedShipsCount = ownShips.length - sunkenShipsCount;
    int pointsForSaves =
        Battleship.saveValue * (ownShips.length - sunkenShipsCount);
    debugPrint("${player.name}'s ships spared: "
        "$sparedShipsCount --> $pointsForSaves points");

    return pointsForSaves;
  }

  int _getHitPointsFor(
    Player player,
    Iterable<RecordedMove<BattleshipMove>> rivalMoves,
  ) {
    var ownBombs = placedItems.keys.whereType<BattleshipBomb>().toList();
    // Every element of rivalShipCells is a set of cells that belong to one ship
    List<Set<BattleshipBoardCell>> rivalShipCellGroups = [];
    for (var rivalMove in rivalMoves) {
      rivalShipCellGroups.addAll(rivalMove.move.placedShipCells());
    }

    // Own bombs hitting rival ships
    int hitsCount = 0;
    for (var ownBomb in ownBombs) {
      var ownBombCell = placedItems[ownBomb]!;
      for (var rivalShipCellGroup in rivalShipCellGroups) {
        if (rivalShipCellGroup.contains(ownBombCell)) {
          hitsCount++;
        }
      }
    }
    int pointsForHits = Battleship.hitValue * hitsCount;
    debugPrint("Hits by ${player.name}: "
        "$hitsCount --> $pointsForHits points");

    return pointsForHits;
  }
}
