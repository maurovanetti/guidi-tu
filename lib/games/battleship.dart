import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/screens/outcome_screen.dart';
import '/screens/turn_play_screen.dart';
import 'battleship/battleship_board.dart';
import 'battleship/battleship_bomb.dart';
import 'battleship/battleship_module.dart';
import 'battleship/battleship_ship.dart';
import 'battleship/incremental_battleship_outcome.dart';
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
          gameFeatures: battleship,
          moveReceiver: moveReceiver as MoveReceiver<BattleshipMove>,
        );

  @override
  createState() => BattleshipGameAreaState();
}

class BattleshipGameAreaState extends GameAreaState<BattleshipMove>
    with Gendered, TeamAware {
  late final BattleshipModule _gameModule;

  @override
  void initState() {
    // Relative likelihood of hitting a ship (not necessarily sinking it):
    // 2 players: 5 bombs for 10 target cells = 5 * 10 = 50
    // 3 players: 4 bombs for 8 target cells = 2 * 4 * 8 = 64
    // 4 players: 3 bombs for 7 target cells = 3 * 3 * 7 = 63
    // 5 players: 3 bombs for 6 target cells = 4 * 3 * 6 = 72
    // 6 players: 2 bombs for 6 target cells = 5 * 2 * 6 = 60
    // 7 players: 2 bombs for 6 target cells = 6 * 2 * 6 = 72
    int shipCount;
    int bombCount;
    switch (players.length) {
      case 2:
        shipCount = 7;
        bombCount = 5;
        break;
      case 3:
        shipCount = 5;
        bombCount = 4;
        break;
      case 4:
        shipCount = 4;
        bombCount = 3;
        break;
      case 5:
        shipCount = 3;
        bombCount = 3;
        break;
      case 6:
      case 7:
      default:
        shipCount = 3;
        bombCount = 2;
        break;
    }
    _gameModule = BattleshipModule(
      setReady: widget.setReady,
      shipCount: shipCount,
      bombCount: bombCount,
    );
    super.initState();
  }

  @override
  BattleshipMove getMove() => BattleshipMove(
        placedItems: _gameModule.board.placedItems,
      );

  @override
  Widget build(BuildContext context) => GameWidget(game: _gameModule);
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
