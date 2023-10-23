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
    required this.changeN,
    required this.quickChangeNStart,
    required this.quickChangeNEnd,
    this.enabled = true,
  });

  final String assetPath;
  final int delta;
  final Color? color;
  final void Function(int delta) changeN;
  final void Function(int nStart) quickChangeNStart;
  final void Function() quickChangeNEnd;
  final bool enabled;

  @override
  build(BuildContext context) {
    var actualColor = color ?? Theme.of(context).colorScheme.primary;
    return GestureDetector(
      child: IconButton(
        constraints: const BoxConstraints.tightFor(height: 63),
        icon: ImageIcon(
          AssetImage('assets/images/$assetPath'),
          color: enabled ? actualColor : actualColor.withOpacity(0.1),
          size: 250,
        ),
        onPressed: enabled ? () => changeN(delta) : null,
      ),
      onLongPress: () => quickChangeNStart(delta),
      onLongPressUp: () => quickChangeNEnd(),
    );
  }
}

class _UpArrowButton extends ArrowButton {
  _UpArrowButton({
    super.key, // ignore: unused_element
    super.enabled = true, // ignore: unused_element
    super.color, // ignore: unused_element
    required ShotGameAreaState shotState,
  }) : super(
          assetPath: 'ui/up.png',
          delta: 1,
          changeN: shotState.changeN,
          quickChangeNStart: shotState.longPressStart,
          quickChangeNEnd: shotState.longPressEnd,
        );
}

class _DownArrowButton extends ArrowButton {
  _DownArrowButton({
    super.key, // ignore: unused_element
    super.enabled = true, // ignore: unused_element
    super.color, // ignore: unused_element
    required ShotGameAreaState shotState,
  }) : super(
          assetPath: 'ui/down.png',
          delta: -1,
          changeN: shotState.changeN,
          quickChangeNStart: shotState.longPressStart,
          quickChangeNEnd: shotState.longPressEnd,
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
        QuickMessage()
            .showQuickMessage("Tieni premuto per azzerare", context: context);
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

class ShotOutcomeState extends StoriesScreenState<ShotMove> {
  // Folk dream interpretation for lottery prediction, revised
  static const smorfia = [
    "il neonato",
    "l'Italia",
    "la bambina",
    "la gatta",
    "il maialino",
    "la mano",
    "guarda giù",
    "il vaso",
    "la vergine",
    "i figli",
    "i fagioli",
    "i topini",
    "il soldato",
    "il santo",
    "l'etilometro",
    "il ragazzo",
    "il sedere",
    "la sfortuna",
    "il sangue",
    "la risata",
    "la festa",
    "senza vestiti",
    "il matto",
    "il tonto",
    "le guardie",
    "Natale",
    "la santa",
    "il pitale",
    "i seni",
    "il papà",
    "il tenente",
    "il padrone",
    "il capitone",
    "gli anni",
    "la testa",
    "l'uccellino",
    "le nacchere",
    "il monaco",
    "le botte",
    "il nodo",
    "la noia",
    "il coltello",
    "il caffè",
    "il gossip",
    "la prigione",
    "l'acqua minerale",
    "i soldi",
    "lo scheletro",
    "che parla",
    "la carne",
    "il pane",
    "il giardino",
    "la mamma",
    "il vecchio",
    "il cappello",
    "la musica",
    "la caduta",
    "il gobbo",
    "il rider",
    "i peli",
    "il lamento",
    "il cacciatore",
    "la preda",
    "la sposa",
    "il frac",
    "il pianto",
    "le due single",
    "nella chitarra",
    "la zuppa",
    "sottosopra",
    "il palazzo",
    "l'omaccio",
    "la meraviglia",
    "l'ospedale",
    "la grotta",
    "Pulcinella",
    "la fontana",
    "le gambe",
    "la bella",
    "il ladro",
    "la bocca",
    "i fiori",
    "la tavola",
    "il maltempo",
    "la chiesa",
    "le anime",
    "la bottega",
    "i pidocchi",
    "i caciocavalli",
    "la vecchia",
    "la paura",
    "non c'è",
    "l'uranio",
    "la app",
    "il plutonio",
    "la finestra",
    "sottosopra",
    "la smorfia",
    "il collegio",
    "il bilico",
  ];

  late final Map<Player, String> _playerNicknames;

  @override
  // ignore: avoid-long-functions
  void tellPlayerStories() {
    _playerNicknames = <Player, String>{};
    for (var playerIndex in TurnAware.turns) {
      var player = players[playerIndex];
      String story = '';
      switch (Random().nextInt(3)) {
        case 0:
          story = " ha fatto del suo meglio";
          break;

        case 1:
          story = " ha giocato pulito";
          break;

        case 2:
          story = " ha fatto la sua mossa";
          break;
      }
      var rm = getRecordedMove(player);
      var move = rm.move;
      var time = rm.time;
      if (move.n == 0) {
        story = player.t(
          " è stato immobile",
          " è stata immobile",
          " non ha mosso un dito",
        );
      } else if (move.n > 100) {
        story = " ha assaltato il cielo";
      } else if (move.n < -100) {
        story = player.t(
          " è disceso negli inferi",
          " è discesa negli inferi",
          " ha raggiunto gli inferi",
        );
        // ignore: prefer-moving-to-variable
      } else if (move.n.abs() > 20) {
        story = player.t(
          " si è dato da fare",
          " si è data da fare",
          " ci ha messo impegno",
        );
      }
      if (time < 1) {
        story += " per un istante";
      } else if (time < 2) {
        story += " con rapidità";
      } else if (time > 5) {
        story += " con calma";
      } else if (time > 10) {
        story += " con molta calma";
      } else if (time > 20) {
        story += " in tempi geologici";
      } else if (time > 30) {
        story += " in tempi astronomici";
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
