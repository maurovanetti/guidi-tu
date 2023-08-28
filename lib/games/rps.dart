import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/screens/outcome_screen.dart';
import '/screens/turn_play_screen.dart';
import 'game_area.dart';
import 'rps/incremental_rps_outcome.dart';
import 'rps/rps_module.dart';

class RockPaperScissors extends TurnPlayScreen {
  RockPaperScissors() : super(key: WidgetKeys.rps, gameFeatures: rps);

  @override
  bool get isReadyAtStart => false;

  @override
  createState() => TurnPlayState<RockPaperScissorsMove>();
}

class RockPaperScissorsGameArea extends GameArea<RockPaperScissorsMove> {
  RockPaperScissorsGameArea({
    super.key,
    required super.setReady,
    required MoveReceiver moveReceiver,
    required super.startTime,
  }) : super(
          gameFeatures: rps,
          moveReceiver: moveReceiver as MoveReceiver<RockPaperScissorsMove>,
        );

  @override
  createState() => RockPaperScissorsGameAreaState();
}

class RockPaperScissorsGameAreaState
    extends GameAreaState<RockPaperScissorsMove> with Gendered, TeamAware {
  late final RockPaperScissorsModule _gameModule;

  @override
  void initState() {
    super.initState();
    int gestureCount = players.length + 2;
    _gameModule = RockPaperScissorsModule(
      setReady: widget.setReady,
      gestureCount: gestureCount,
    );
  }

  @override
  MoveUpdate<RockPaperScissorsMove> getMoveUpdate() => (
        newMove: RockPaperScissorsMove(sequence: _gameModule.currentSequence),
        updatedOldMoves: {},
      );

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: _gameModule);
  }
}

class RockPaperScissorsOutcome extends OutcomeScreen {
  RockPaperScissorsOutcome({super.key}) : super(gameFeatures: rps);

  @override
  RockPaperScissorsOutcomeState createState() =>
      RockPaperScissorsOutcomeState();
}

class RockPaperScissorsOutcomeState
    extends OutcomeScreenState<RockPaperScissorsMove> {
  final _incrementalScores = <IncrementalRockPaperScissorsScore>[];

  @override
  initState() {
    super.initState();
    for (var playerIndex in TurnAware.turns) {
      var player = players[playerIndex];
      var recordedMove = getRecordedMove(player);
      _incrementalScores.add(IncrementalRockPaperScissorsScore(
        recordedMove: recordedMove,
      ));
    }
  }

  @override
  void initOutcome() {
    repeatable = true;
    outcomeWidget = IncrementalRockPaperScissorsOutcome(
      incrementalScores: _incrementalScores,
    );
  }
}

sealed class RockPaperScissorsGesture {
  static const path = "rps/hands";

  ({String color, String grey}) get assetPaths;

  const RockPaperScissorsGesture();

  bool beats(RockPaperScissorsGesture other);

  bool isBeatenBy(RockPaperScissorsGesture other) {
    return other.beats(this);
  }

  bool winsOver(RockPaperScissorsSequence others) {
    return others.any(beats) && !others.any(isBeatenBy);
  }

  bool losesTo(RockPaperScissorsSequence others) {
    return others.any(isBeatenBy) && !others.any(beats);
  }

  bool drawsWith(RockPaperScissorsSequence others) {
    return others.every((other) => other == this);
  }

  bool standsOffWith(RockPaperScissorsSequence others) {
    return others.any(beats) && others.any(isBeatenBy);
  }
}

class Rock extends RockPaperScissorsGesture {
  static const _instance = Rock._internal();

  @override
  get assetPaths => (
        color: '${RockPaperScissorsGesture.path}/rock.png',
        grey: '${RockPaperScissorsGesture.path}/rock_grey.png',
      );

  const Rock._internal();

  factory Rock() => _instance;

  @override
  bool beats(RockPaperScissorsGesture other) {
    return other is Scissors;
  }
}

class Paper extends RockPaperScissorsGesture {
  static const _instance = Paper._internal();

  @override
  get assetPaths => (
        color: '${RockPaperScissorsGesture.path}/paper.png',
        grey: '${RockPaperScissorsGesture.path}/paper_grey.png',
      );

  const Paper._internal();

  factory Paper() => _instance;

  @override
  bool beats(RockPaperScissorsGesture other) {
    return other is Rock;
  }
}

class Scissors extends RockPaperScissorsGesture {
  static const _instance = Scissors._internal();

  @override
  get assetPaths => (
        color: '${RockPaperScissorsGesture.path}/scissors.png',
        grey: '${RockPaperScissorsGesture.path}/scissors_grey.png',
      );

  const Scissors._internal();

  factory Scissors() => _instance;

  @override
  bool beats(RockPaperScissorsGesture other) {
    return other is Paper;
  }
}

typedef RockPaperScissorsSequence = List<RockPaperScissorsGesture>;

class RockPaperScissorsMove extends Move {
  final RockPaperScissorsSequence sequence;

  const RockPaperScissorsMove({
    required this.sequence,
  });

  @override
  int getPointsFor(Player player, Iterable<RecordedMove> allMoves) {
    var rivalMoves = RecordedMove.otherMoves(player, allMoves)
        .cast<RecordedMove<RockPaperScissorsMove>>();
    int points = 0;
    var otherSequences = rivalMoves.map((rivalMove) => rivalMove.move.sequence);
    for (int i = 0; i < sequence.length; i++) {
      var gesture = sequence[i];
      var otherGestures =
          otherSequences.map((otherSequence) => otherSequence[i]).toList();
      if (gesture.winsOver(otherGestures)) {
        points++;
      }
    }
    return points;
  }
}
