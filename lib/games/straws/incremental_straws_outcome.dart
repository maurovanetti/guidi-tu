import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/games/straws.dart';
import 'straws_replay.dart';

class IncrementalStrawsOutcome extends StatefulWidget {
  const IncrementalStrawsOutcome({
    super.key,
    required this.recordedMoves,
  });

  final List<RecordedMove<StrawsMove>> recordedMoves;

  @override
  IncrementalStrawsOutcomeState createState() =>
      IncrementalStrawsOutcomeState();
}

class IncrementalStrawsOutcomeState extends State<IncrementalStrawsOutcome> {
  Player _player = Player.none;
  late final StrawsReplay _replay;
  late final GameWidget _gameWidget = GameWidget(game: _replay);
  late final Timer _timer;
  int _moveIndex = 0;

  @override
  initState() {
    super.initState();
    List<Map<String, dynamic>> strawsToDisplay = [];
    for (var move in widget.recordedMoves) {
      strawsToDisplay.add(move.move.straw.toJson());
    }
    _replay = StrawsReplay(strawsToDisplay);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      var recordedMove = widget.recordedMoves[_moveIndex];
      _display(recordedMove);
      _moveIndex = (_moveIndex + 1) % widget.recordedMoves.length;
    });
  }

  Future<void> _display(RecordedMove<StrawsMove> recordedMove) async {
    if (!mounted) {
      return;
    }
    _replay.pick(recordedMove.move.straw);
    setState(() {
      _player = recordedMove.player;
    });
  }

  @override
  dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SqueezeOrScroll(
        squeeze: false,
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
