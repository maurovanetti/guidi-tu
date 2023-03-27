import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/screens/outcome_screen.dart';
import '/screens/turn_play_screen.dart';
import 'flame/battleship_module.dart';
import 'game_area.dart';

class Battleship extends TurnPlayScreen {
  static const saveValue = 5; // points for each own ship saved from enemy hits
  static const sinkValue = 1; // points for each enemy ship hit (not every hit!)

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
      incrementalScores.add(IncrementalBattleshipScore(
        recordedMove: getRecordedMove(player),
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

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      for (var x in widget.incrementalScores) {
        await schedule([_setUp(x)], 3.0);
      }
    });
  }

  Future<void> schedule(Iterable<Future<void>> tasks, double seconds) async {
    var _ = await Future.wait(tasks);
    return Future.delayed(Duration(
      milliseconds: (Duration.millisecondsPerSecond * seconds).toInt(),
    ));
  }

  Future<void> _setUp(IncrementalBattleshipScore score) async {
    setState(() {
      _player = score.recordedMove.player;
    });
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
    return SqueezeOrScroll(
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
              _buildTableRow('🦆', (x) => x.pointsForShips.toString()),
              // ignore: avoid-non-ascii-symbols
              _buildTableRow('🎯', (x) => x.pointsForHits.toString()),
            ],
          ),
        ),
        const Text(
          "${Battleship.saveValue} pt. per ogni galleggiante salvato.",
        ),
        const Text(
          "${Battleship.sinkValue} pt. per ogni colpo andato a segno.",
        ),
        const Gap(),
      ],
      centralChild: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          color: Colors.blue,
          child: const Center(
            child: Text(
              "TODO",
              style: TextStyle(fontSize: 48),
            ),
          ),
        ),
      ),
      bottomChildren: [
        if (_player != null) PlayerTag(_player!),
      ],
    );
  }
}

class IncrementalBattleshipScore {
  final RecordedMove<BattleshipMove> recordedMove;
  final int pointsForShips = 0;
  final int pointsForHits = 0;

  IncrementalBattleshipScore({required this.recordedMove});
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

  // Not using a getter here to indicate that the computation is expensive
  Map<BattleshipBomb, BattleshipBoardCell> placedBombs() {
    Map<BattleshipBomb, BattleshipBoardCell> pb = {};
    for (var entry
        in placedItems.entries.where((e) => e.key is BattleshipBomb)) {
      pb[entry.key as BattleshipBomb] = entry.value;
    }
    return pb;
  }

  @override
  int getPointsFor(Player player, Iterable<RecordedMove> allMoves) {
    var ownShips = placedItems.keys.whereType<BattleshipShip>().toList();
    var ownBombs = placedItems.keys.whereType<BattleshipBomb>().toList();
    var rivalMoves = RecordedMove.otherMoves(player, allMoves)
        .cast<RecordedMove<BattleshipMove>>();
    var rivalPlacedItems =
        Map.fromEntries(rivalMoves.expand((m) => m.move.placedItems.entries));
    var rivalBombs = rivalPlacedItems.keys.whereType<BattleshipBomb>().toList();
    var rivalShips = rivalPlacedItems.keys.whereType<BattleshipShip>().toList();

    // Rival bombs hitting own ships
    for (var rivalBomb in rivalBombs) {
      BattleshipBoardCell rivalBombCell = rivalPlacedItems[rivalBomb]!;
      BattleshipShip? ownSunkenShip;
      for (var ownShip in ownShips) {
        BattleshipBoardCell ownShipCell = placedItems[ownShip]!;
        if (ownShip.isHit(shipCell: ownShipCell, bombCell: rivalBombCell)) {
          ownSunkenShip = ownShip;
          // Break here, because one bomb is enough to sink a ship
          break;
        }
      }
      // Can remove none if no ship was hit.
      // ignore: avoid-ignoring-return-values
      ownShips.remove(ownSunkenShip);
    }
    // Points for own ships saved must be counted after all sinking is done
    int points = Battleship.saveValue * ownShips.length;
    debugPrint("${player.name}'s ships spared: ${ownShips.length} -->"
        " $points points");

    // Own bombs hitting rival ships
    int sunkenShipsCount = 0;
    for (var ownBomb in ownBombs) {
      BattleshipBoardCell ownBombCell = placedItems[ownBomb]!;
      List<BattleshipShip> rivalSunkenShips = [];
      for (var rivalShip in rivalShips) {
        BattleshipBoardCell rivalShipCell = rivalPlacedItems[rivalShip]!;
        if (rivalShip.isHit(shipCell: rivalShipCell, bombCell: ownBombCell)) {
          rivalSunkenShips.add(rivalShip);
          // Don't break here, because a bomb can hit ships of multiple rivals
          points += Battleship.sinkValue;
          sunkenShipsCount++;
        }
      }
      // Sunken ships are removed from the list of rival ships, which prevents
      // one sinking from being counted multiple times: players don't get more
      // points by bombing the same ship twice
      rivalShips =
          rivalShips.where((ship) => !rivalSunkenShips.contains(ship)).toList();
    }
    debugPrint("Ships sunk by ${player.name}: $sunkenShipsCount -->"
        " ${sunkenShipsCount * Battleship.sinkValue} points");

    return points;
  }
}
