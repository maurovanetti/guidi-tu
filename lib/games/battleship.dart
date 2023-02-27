import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/game_features.dart';
import '/games/turn_play.dart';
import '../common/turn_aware.dart';
import 'flame/battleship_board.dart';
import 'flame/battleship_bomb.dart';
import 'flame/battleship_item.dart';
import 'flame/battleship_module.dart';
import 'flame/battleship_ship.dart';
import 'outcome_screen.dart';

class Battleship extends TurnPlay {
  static const saveValue = 5; // points for each own ship saved from enemy hits
  static const sinkValue = 1; // points for each enemy ship hit (not every hit!)

  Battleship({super.key}) : super(gameFeatures: battleship);

  @override
  createState() => BattleshipState();
}

class BattleshipState extends TurnPlayState<BattleshipMove> {
  late BattleshipModule _gameModule;

  @override
  bool get isReadyAtStart => false;

  @override
  BattleshipMove get lastMove => BattleshipMove(
        player: TurnAware.currentPlayer,
        time: elapsedSeconds,
        placedItems: _gameModule.board.placedItems,
      );

  @override
  void initState() {
    _gameModule = BattleshipModule(setReady: setReady);
    super.initState();
  }

  @override
  buildGameArea() => GameWidget(game: _gameModule);
}

class BattleshipOutcome extends OutcomeScreen {
  BattleshipOutcome({super.key}) : super(gameFeatures: battleship);

  @override
  BattleshipOutcomeState createState() => BattleshipOutcomeState();
}

class BattleshipOutcomeState extends OutcomeScreenState<BattleshipMove> {
  @override
  initState() {
    super.initState();
    for (var playerIndex in TurnAware.turns) {
      // TODO
      // ignore: unused_local_variable
      var player = players[playerIndex];
    }
  }
}

class BattleshipMove extends MoveWithAttribution {
  final Map<BattleshipItem, BattleshipBoardCell> placedItems;

  BattleshipMove({
    required super.player,
    required super.time,
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
  int getPointsWith(Iterable<Move> allMoves) {
    var ownShips = placedItems.keys.whereType<BattleshipShip>().toList();
    var ownBombs = placedItems.keys.whereType<BattleshipBomb>().toList();
    var rivalPlacedItems = _otherPlacedItems(allMoves);
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
    int sunkensShipsCount = 0;
    for (var ownBomb in ownBombs) {
      BattleshipBoardCell ownBombCell = placedItems[ownBomb]!;
      List<BattleshipShip> rivalSunkenShips = [];
      for (var rivalShip in rivalShips) {
        BattleshipBoardCell rivalShipCell = rivalPlacedItems[rivalShip]!;
        if (rivalShip.isHit(shipCell: rivalShipCell, bombCell: ownBombCell)) {
          rivalSunkenShips.add(rivalShip);
          // Don't break here, because a bomb can hit ships of multiple rivals
          points += Battleship.sinkValue;
          sunkensShipsCount++;
        }
      }
      // Sunken ships are removed from the list of rival ships, which prevents
      // one sinking from being counted multiple times: players don't get more
      // points by bombing the same ship twice
      rivalShips =
          rivalShips.where((ship) => !rivalSunkenShips.contains(ship)).toList();
    }
    debugPrint("Ships sunk by ${player.name}: $sunkensShipsCount -->"
        " ${sunkensShipsCount * Battleship.sinkValue} points");

    return points;
  }

  Map<BattleshipItem, BattleshipBoardCell> _otherPlacedItems(
    Iterable<Move> allMoves,
  ) {
    var rivalMoves = otherMoves<BattleshipMove>(allMoves);
    return Map.fromEntries(rivalMoves.expand((m) => m.placedItems.entries));
  }
}
