import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/screens/outcome_screen.dart';
import '/screens/turn_play_screen.dart';
import 'game_area.dart';
import 'straws/incremental_straws_outcome.dart';
import 'straws/straws_module.dart';
import 'straws/straws_straw.dart';

class Straws extends TurnPlayScreen {
  Straws() : super(key: WidgetKeys.straws, gameFeatures: straws);

  @override
  final isReadyAtStart = true;

  @override
  createState() => TurnPlayState<StrawsMove>();
}

class StrawsGameArea extends GameArea<StrawsMove> {
  StrawsGameArea({
    super.key,
    required super.setReady,
    required MoveReceiver moveReceiver,
    required super.startTime,
  }) : super(
          gameFeatures: straws,
          moveReceiver: moveReceiver as MoveReceiver<StrawsMove>,
        );

  @override
  createState() => StrawsGameAreaState();
}

class StrawsGameAreaState extends GameAreaState<StrawsMove>
    with Gendered, TeamAware {
  late final StrawsModule _gameModule;

  @override
  void initState() {
    super.initState();
    _gameModule = StrawsModule(setReady: widget.setReady);
  }

  void _nextStraw() {
    _gameModule.pick();
  }

  @override
  StrawsMove getMove() => StrawsMove(straw: _gameModule.pickedStraw);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GameWidget(game: _gameModule),
        ),
        CustomButton(
          text: "Prendine un altro",
          important: false,
          onPressed: _nextStraw,
        ),
      ],
    );
  }
}

class StrawsOutcome extends OutcomeScreen {
  StrawsOutcome({super.key}) : super(gameFeatures: straws);

  @override
  StrawsOutcomeState createState() => StrawsOutcomeState();
}

class StrawsOutcomeState extends OutcomeScreenState<StrawsMove> {
  List<RecordedMove<StrawsMove>> recordedMoves = [];

  @override
  initState() {
    super.initState();
    for (var playerIndex in TurnAware.turns) {
      var player = players[playerIndex];
      var recordedMove = getRecordedMove(player);
      recordedMoves.add(recordedMove);
    }
  }

  @override
  void initOutcome() {
    repeatable = true;
    outcomeWidget = IncrementalStrawsOutcome(recordedMoves: recordedMoves);
  }
}

class StrawsMove extends Move {
  StrawsStraw straw;

  StrawsMove({required this.straw});

  @override
  int getPointsFor(Player player, Iterable<RecordedMove> allMoves) =>
      straw.length;
}
