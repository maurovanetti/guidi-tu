import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/screens/outcome_screen.dart';
import '/screens/turn_play_screen.dart';
import 'game_area.dart';
import 'rps/incremental_rps_outcome.dart';
import 'rps/rps_module.dart';

class RockPaperScissors extends TurnPlayScreen {
  @override
  final bool isReadyAtStart = false;

  RockPaperScissors() : super(key: WidgetKeys.rps, gameFeatures: rps);

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
    int gestureCount = players.length + 2;
    _gameModule = RockPaperScissorsModule(
      setReady: widget.setReady,
      gestureCount: gestureCount,
    );
    super.initState();
  }

  @override
  RockPaperScissorsMove getMove() =>
      RockPaperScissorsMove(sequence: _gameModule.currentSequence);

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
  List<IncrementalRockPaperScissorsScore> incrementalScores = [];

  @override
  initState() {
    super.initState();
    for (var playerIndex in TurnAware.turns) {
      var player = players[playerIndex];
      var recordedMove = getRecordedMove(player);
      incrementalScores.add(IncrementalRockPaperScissorsScore(
        recordedMove: recordedMove,
      ));
    }
  }

  @override
  void initOutcome() {
    repeatable = true;
    outcomeWidget = IncrementalRockPaperScissorsOutcome(
      incrementalScores: incrementalScores,
    );
  }
}

sealed class RockPaperScissorsGesture {
  String get hand;

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
  static final Rock _instance = Rock._internal();

  @override
  String get hand => 'S';

  Rock._internal();
  factory Rock() => _instance;

  @override
  bool beats(RockPaperScissorsGesture other) {
    return other is Scissors;
  }
}

class Paper extends RockPaperScissorsGesture {
  static final Paper _instance = Paper._internal();

  @override
  String get hand => 'C';

  Paper._internal();
  factory Paper() => _instance;

  @override
  bool beats(RockPaperScissorsGesture other) {
    return other is Rock;
  }
}

class Scissors extends RockPaperScissorsGesture {
  static final Scissors _instance = Scissors._internal();

  @override
  String get hand => 'F';

  Scissors._internal();
  factory Scissors() => _instance;

  @override
  bool beats(RockPaperScissorsGesture other) {
    return other is Paper;
  }
}

typedef RockPaperScissorsSequence = List<RockPaperScissorsGesture>;

class RockPaperScissorsMove extends Move {
  final RockPaperScissorsSequence sequence;

  RockPaperScissorsMove({
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
          otherSequences.map((sequence) => sequence[i]).toList();
      if (gesture.winsOver(otherGestures)) {
        points++;
      }
    }
    return points;
  }
}
