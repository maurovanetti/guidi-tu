// This version of the app is in Italian only.
// ignore_for_file: avoid-non-ascii-symbols

// Lots of magic numbers here, but they're all related to the game mechanics.
// ignore_for_file: no-magic-number

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '/common/common.dart';
import '/screens/stories_screen.dart';
import 'game_area.dart';

class ShotGameAreaState<T extends ShotMove> extends GameAreaState<T> {
  Timer? _longPressTimer;

  @protected
  int n = 0;

  void changeN(int delta) => setState(() => n += delta);

  void resetN() => setState(() => n = 0);

  void longPressStart(int delta) {
    _longPressTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      changeN(delta);
    });
  }

  void longPressEnd() {
    _longPressTimer?.cancel();
  }

  @override
  MoveUpdate<T> getMoveUpdate() =>
      (newMove: ShotMove(n: n) as T, updatedOldMoves: {});

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShotControls(n: n, stretched: true, shotState: this),
    );
  }
}

class ArrowButton extends StatelessWidget {
  const ArrowButton({
    super.key,
    required this.assetPath,
    required this.delta,
    required this.color,
    required this.onChangeN,
    required this.onQuickChangeNStart,
    required this.onQuickChangeNEnd,
    this.enabled = true,
  });

  final String assetPath;
  final int delta;
  final Color? color;
  final OnSetInteger onChangeN;
  final OnSetInteger onQuickChangeNStart;
  final VoidCallback onQuickChangeNEnd;
  final bool enabled;

  @override
  build(BuildContext context) {
    var actualColor = color ?? Theme.of(context).colorScheme.primary;
    return GestureDetector(
      child: IconButton(
        constraints: const BoxConstraints.tightFor(height: 63),
        icon: ImageIcon(
          AssetImage('assets/images/$assetPath'),
          color: enabled ? actualColor : actualColor.withValues(alpha: 0.1),
          size: 250,
        ),
        onPressed: enabled ? () => onChangeN(delta) : null,
      ),
      onLongPress: () => onQuickChangeNStart(delta),
      onLongPressUp: () => onQuickChangeNEnd(),
    );
  }
}

class _UpArrowButton extends ArrowButton {
  _UpArrowButton({
    super.key, // ignore: unused_element_parameter
    super.enabled = true, // ignore: unused_element_parameter
    super.color, // ignore: unused_element_parameter
    required ShotGameAreaState shotState,
  }) : super(
          assetPath: 'ui/up.png',
          delta: 1,
          onChangeN: shotState.changeN,
          onQuickChangeNStart: shotState.longPressStart,
          onQuickChangeNEnd: shotState.longPressEnd,
        );
}

class _DownArrowButton extends ArrowButton {
  _DownArrowButton({
    super.key, // ignore: unused_element_parameter
    super.enabled = true, // ignore: unused_element_parameter
    super.color, // ignore: unused_element_parameter
    required ShotGameAreaState shotState,
  }) : super(
          assetPath: 'ui/down.png',
          delta: -1,
          onChangeN: shotState.changeN,
          onQuickChangeNStart: shotState.longPressStart,
          onQuickChangeNEnd: shotState.longPressEnd,
        );
}

class ShotControls extends StatelessWidget {
  const ShotControls({
    super.key,
    required this.n,
    required this.shotState,
    required this.stretched,
    this.caption = '',
  });

  final int n;
  final ShotGameAreaState shotState;
  final bool stretched;
  final String caption;

  @override
  build(BuildContext context) {
    var theme = Theme.of(context);
    var primaryColor = theme.colorScheme.primary;
    var displayButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: ContinuousRectangleBorder(
          side: BorderSide(color: primaryColor, width: 5),
        ),
      ),
      onLongPress: shotState.resetN,
      onPressed: () {
        QuickMessage().showQuickMessage(
          get$(context).longTapToReset,
          context: context,
        );
      },
      child: FittedText(
        n.toString(),
        style:
            theme.textTheme.displayLarge!.copyWith(fontWeight: FontWeight.bold),
      ),
    );
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            stretched ? CrossAxisAlignment.stretch : CrossAxisAlignment.center,
        children: [
          _UpArrowButton(shotState: shotState),
          if (caption.isNotEmpty)
            Padding(
              padding: StyleGuide.narrowPadding,
              child: Text(
                caption,
                style: theme.textTheme.headlineLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          displayButton,
          _DownArrowButton(shotState: shotState),
        ],
      ),
    );
  }
}

class ShotOutcomeState extends StoriesScreenState<ShotMove> with Localized {
  // Folk dream interpretation for lottery prediction, revised

  late final Map<Player, String> _playerNicknames;
  late final List<String> smorfia;

  @override
  void didChangeDependencies() {
    smorfia = [
      $.smorfia0,
      $.smorfia1,
      $.smorfia2,
      $.smorfia3,
      $.smorfia4,
      $.smorfia5,
      $.smorfia6,
      $.smorfia7,
      $.smorfia8,
      $.smorfia9,
      $.smorfia10,
      $.smorfia11,
      $.smorfia12,
      $.smorfia13,
      $.smorfia14,
      $.smorfia15,
      $.smorfia16,
      $.smorfia17,
      $.smorfia18,
      $.smorfia19,
      $.smorfia20,
      $.smorfia21,
      $.smorfia22,
      $.smorfia23,
      $.smorfia24,
      $.smorfia25,
      $.smorfia26,
      $.smorfia27,
      $.smorfia28,
      $.smorfia29,
      $.smorfia30,
      $.smorfia31,
      $.smorfia32,
      $.smorfia33,
      $.smorfia34,
      $.smorfia35,
      $.smorfia36,
      $.smorfia37,
      $.smorfia38,
      $.smorfia39,
      $.smorfia40,
      $.smorfia41,
      $.smorfia42,
      $.smorfia43,
      $.smorfia44,
      $.smorfia45,
      $.smorfia46,
      $.smorfia47,
      $.smorfia48,
      $.smorfia49,
      $.smorfia50,
      $.smorfia51,
      $.smorfia52,
      $.smorfia53,
      $.smorfia54,
      $.smorfia55,
      $.smorfia56,
      $.smorfia57,
      $.smorfia58,
      $.smorfia59,
      $.smorfia60,
      $.smorfia61,
      $.smorfia62,
      $.smorfia63,
      $.smorfia64,
      $.smorfia65,
      $.smorfia66,
      $.smorfia67,
      $.smorfia68,
      $.smorfia69,
      $.smorfia70,
      $.smorfia71,
      $.smorfia72,
      $.smorfia73,
      $.smorfia74,
      $.smorfia75,
      $.smorfia76,
      $.smorfia77,
      $.smorfia78,
      $.smorfia79,
      $.smorfia80,
      $.smorfia81,
      $.smorfia82,
      $.smorfia83,
      $.smorfia84,
      $.smorfia85,
      $.smorfia86,
      $.smorfia87,
      $.smorfia88,
      $.smorfia89,
      $.smorfia90,
      $.smorfia91,
      $.smorfia92,
      $.smorfia93,
      $.smorfia94,
      $.smorfia95,
      $.smorfia96,
      $.smorfia97,
      $.smorfia98,
      $.smorfia99,
    ];
    super.didChangeDependencies();
  }

  @override
  void tellPlayerStories() {
    _playerNicknames = <Player, String>{};
    for (var playerIndex in TurnAware.turns) {
      var player = players[playerIndex];
      final stories = [
        $.shotStory1,
        $.shotStory2,
        $.shotStory3,
      ];
      String story = player.t(stories[Random().nextInt(3)]);
      var rm = getRecordedMove(player);
      var move = rm.move;
      var time = rm.time;
      if (move.n == 0) {
        story = player.t($.shot0);
      } else if (move.n > 100) {
        story = player.t($.shotOver100);
      } else if (move.n < -100) {
        story = player.t($.shotUnderMinus100);
        // ignore: prefer-moving-to-variable
      } else if (move.n.abs() > 20) {
        story = player.t($.shotOverAbsolute20);
      }
      if (time < 1) {
        story += $.shotStorySuffix1;
      } else if (time < 2) {
        story += $.shotStorySuffix2;
      } else if (time > 5) {
        story += $.shotStorySuffix3;
      } else if (time > 10) {
        story += $.shotStorySuffix4;
      } else if (time > 20) {
        story += $.shotStorySuffix5;
      } else if (time > 30) {
        story += $.shotStorySuffix6;
      }
      playerStories[playerIndex] = story;
      _playerNicknames[player] =
          // ignore: prefer-moving-to-variable
          smorfia[move.n.abs() % smorfia.length];
    }
  }

  @override
  PlayerPerformance getPlayerPerformance(Player player) => PlayerPerformance(
        player,
        primaryText: getBestMove(player).n.toString(),
        secondaryText: _playerNicknames[player]!,
      );
}

class ShotMove extends Move {
  final int n;

  const ShotMove({required this.n});

  @override
  int getPointsFor(Player player, Iterable<RecordedMove> allMoves) => n;
}
