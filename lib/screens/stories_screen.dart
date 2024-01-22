// ignore_for_file: avoid-non-ascii-symbols

import 'package:flutter/material.dart';

import '/common/common.dart';
import 'outcome_screen.dart';

abstract class StoriesScreen<T extends Move> extends OutcomeScreen {
  const StoriesScreen({super.key, required super.gameFeatures});

  @override
  StoriesScreenState<T> createState();
}

abstract class StoriesScreenState<T extends Move>
    extends OutcomeScreenState<T> {
  late final List<String> playerStories;

  @override
  initState() {
    super.initState();
    playerStories = List.filled(players.length, '');
    tellPlayerStories();
  }

  void tellPlayerStories();

  PlayerPerformance getPlayerPerformance(Player player);

  @override
  void initOutcome() {
    var textTheme = Theme.of(context).textTheme;
    var widgets = <Widget>[];
    for (var playerIndex in TurnAware.turns) {
      var player = players[playerIndex];
      // ignore: avoid-returning-widgets
      widgets.add(getPlayerPerformance(player));
      widgets.add(
        FittedText(
          playerStories[playerIndex],
          style: textTheme.headlineMedium,
        ),
      );
      widgets.add(const Gap());
    }

    outcomeWidget = ListView(
      // ignore: no-magic-number
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: widgets +
          [
            const Gap(),
            Text(
              "E ora vediamo la classifica!",
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium
                  ?.copyWith(fontStyle: FontStyle.italic),
            ),
            const SafeMarginForCustomFloatingActionButton(),
          ],
    );
  }
}
