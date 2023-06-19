import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '/common/common.dart';
import '/games/straws.dart';
import 'straws_replay.dart';

class IncrementalStrawsOutcome extends StatefulWidget {
  final List<RecordedMove<StrawsMove>> recordedMoves;

  const IncrementalStrawsOutcome({
    super.key,
    required this.recordedMoves,
  });

  @override
  IncrementalStrawsOutcomeState createState() =>
      IncrementalStrawsOutcomeState();
}

class IncrementalStrawsOutcomeState extends State<IncrementalStrawsOutcome> {
  Player _player = NoPlayer();
  late final StrawsReplay _replay;
  late final GameWidget _gameWidget = GameWidget(game: _replay);

  @override
  initState() {
    super.initState();
    List<Map<String, dynamic>> strawsToDisplay = [];
    for (var move in widget.recordedMoves) {
      strawsToDisplay.add(move.move.straw.toJson());
    }
    _replay = StrawsReplay(strawsToDisplay);
    Future.delayed(Duration.zero, _cycleThroughMoves);
  }

  Future<void> _cycleThroughMoves() async {
    for (var x in widget.recordedMoves) {
      await schedule([_display(x)], 2.0);
    }
    await _cycleThroughMoves();
  }

  Future<void> schedule(Iterable<Future<void>> tasks, double seconds) async {
    if (!mounted) return;
    var _ = await Future.wait(tasks);
    if (!mounted) return;
    return Future.delayed(Duration(
      milliseconds: (Duration.millisecondsPerSecond * seconds).toInt(),
    ));
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
