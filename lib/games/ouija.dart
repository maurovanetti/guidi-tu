import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/screens/outcome_screen.dart';
import '/screens/turn_play_screen.dart';
import 'game_area.dart';
import 'ouija/incremental_ouija_outcome.dart';
import 'ouija/ouija_module.dart';

class Ouija extends TurnPlayScreen {
  Ouija() : super(key: WidgetKeys.ouija, gameFeatures: ouija);

  static const guessValue = 5; // points for each letter guessed in right place
  static const missValue = 1; // points for each letter guessed in wrong place

  @override
  bool get isReadyAtStart => false;

  @override
  createState() => TurnPlayState<OuijaMove>();
}

class OuijaGameArea extends GameArea<OuijaMove> {
  OuijaGameArea({
    super.key,
    required super.onChangeReady,
    required MoveReceiver moveReceiver,
    required super.startTime,
  }) : super(
          gameFeatures: ouija,
          moveReceiver: moveReceiver as MoveReceiver<OuijaMove>,
        );

  @override
  createState() => OuijaGameAreaState();
}

class OuijaGameAreaState extends GameAreaState<OuijaMove>
    with Gendered, TeamAware {
  late final OuijaModule _gameModule;

  @override
  void initState() {
    super.initState();
    // Relative likelihood of guessing two letters in the right place:
    // 3 players: 8 chances for 2 rivals = 16
    // 4 players: 6 chances for 3 rivals = 18
    // 5 players: 5 chances for 4 rivals = 20
    // 6 players: 4 chances for 5 rivals = 20
    // 7 players: 4 chances for 6 rivals = 24
    int letterCount;
    switch (players.length) {
      case 2: // forbidden
      case 3:
        letterCount = 8;
        break;

      case 4:
        letterCount = 6;
        break;

      case 5:
        letterCount = 5;
        break;

      case 6:
      case 7:
      default:
        letterCount = 4;
        break;
    }
    _gameModule = OuijaModule(
      onChangeReady: widget.onChangeReady,
      letterCount: letterCount,
    );
  }

  @override
  MoveUpdate<OuijaMove> getMoveUpdate() => (
        newMove: OuijaMove(word: _gameModule.currentWord),
        updatedOldMoves: {},
      );

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: _gameModule);
  }
}

class OuijaOutcome extends OutcomeScreen {
  OuijaOutcome({super.key}) : super(gameFeatures: ouija);

  @override
  OuijaOutcomeState createState() => OuijaOutcomeState();
}

class OuijaOutcomeState extends OutcomeScreenState<OuijaMove> {
  final _incrementalScores = <IncrementalOuijaScore>[];

  @override
  initState() {
    super.initState();
    for (var playerIndex in TurnAware.turns) {
      var player = players[playerIndex];
      var recordedMove = getRecordedMove(player);
      _incrementalScores.add(IncrementalOuijaScore(
        recordedMove: recordedMove,
      ));
    }
  }

  @override
  void initOutcome() {
    repeatable = true;
    outcomeWidget =
        IncrementalOuijaOutcome(incrementalScores: _incrementalScores);
  }
}

class OuijaMove extends Move {
  final String word;

  const OuijaMove({required this.word});

  @override
  int getPointsFor(Player player, Iterable<RecordedMove> allMoves) {
    var rivalMoves = RecordedMove.otherMoves(player, allMoves)
        .cast<RecordedMove<OuijaMove>>();
    int points = 0;
    Iterable<String> otherWords =
        rivalMoves.map((rivalMove) => rivalMove.move.word);
    for (int i = 0; i < word.length; i++) {
      var letter = word[i];
      if (isUsed(letter, otherWords, position: i)) {
        points += Ouija.guessValue;
      } else if (isUsed(letter, otherWords)) {
        points += Ouija.missValue;
      }
    }
    return points;
  }

  bool isUsed(String letter, Iterable<String> otherWords, {int? position}) {
    for (var otherWord in otherWords) {
      if (position == null) {
        if (otherWord.contains(letter)) {
          return true;
        }
      } else {
        if (otherWord[position] == letter) {
          return true;
        }
      }
    }
    return false;
  }
}
