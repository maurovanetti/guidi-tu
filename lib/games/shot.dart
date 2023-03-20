// This version of the app is in Italian only.
// ignore_for_file: avoid-non-ascii-symbols

// Lots of magic numbers here, but they're all related to the game mechanics.
// ignore_for_file: no-magic-number

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '/common/common.dart';
import '/screens/outcome_screen.dart';
import 'game_area.dart';

class ShotGameAreaState<T extends ShotMove> extends GameAreaState<T>
    with QuickMessage {
  Timer? _longPressTimer;

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
  T getMove() => ShotMove(n: n) as T;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShotControls(n: n, stretched: true, shotState: this),
    );
  }
}

class ArrowButton extends StatelessWidget {
  final IconData icon;
  final int delta;
  final Color? color;
  final void Function(int) changeN;
  final void Function(int) quickChangeNStart;
  final void Function() quickChangeNEnd;
  final bool enabled;

  const ArrowButton({
    super.key,
    required this.icon,
    required this.delta,
    required this.color,
    required this.changeN,
    required this.quickChangeNStart,
    required this.quickChangeNEnd,
    this.enabled = true,
  });

  @override
  build(context) {
    var actualColor = color ?? Theme.of(context).colorScheme.primary;
    return GestureDetector(
      child: IconButton(
        icon: Icon(
          icon,
          color: enabled ? actualColor : actualColor.withOpacity(0.1),
          size: 100,
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
          icon: Icons.keyboard_arrow_up_rounded,
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
          icon: Icons.keyboard_arrow_down_rounded,
          delta: -1,
          changeN: shotState.changeN,
          quickChangeNStart: shotState.longPressStart,
          quickChangeNEnd: shotState.longPressEnd,
        );
}

class ShotControls extends StatelessWidget with QuickMessage {
  final int n;
  final ShotGameAreaState shotState;
  final bool stretched;

  const ShotControls({
    super.key,
    required this.n,
    required this.shotState,
    required this.stretched,
  });

  @override
  build(context) {
    var theme = Theme.of(context);
    var displayButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: ContinuousRectangleBorder(
          side: BorderSide(color: theme.colorScheme.primary, width: 5),
        ),
      ),
      onLongPress: shotState.resetN,
      onPressed: () {
        showQuickMessage("Tieni premuto per azzerare", context: context);
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
          displayButton,
          _DownArrowButton(shotState: shotState),
        ],
      ),
    );
  }
}

class ShotOutcomeState extends OutcomeScreenState<ShotMove> {
  // Folk dream interpretation for lottery prediction, revised
  static const List<String> smorfia = [
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

  late final List<String> _playerNicknames;
  late final List<String> _playerStories;

  @override
  initState() {
    super.initState();
    _playerNicknames = List.filled(players.length, '');
    _playerStories = List.filled(players.length, '');
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
        story = player.t(" è stato immobile", " è stata immobile");
      } else if (move.n > 100) {
        story = " ha assaltato il cielo";
      } else if (move.n < -100) {
        story = player.t(" è disceso negli inferi", " è discesa negli inferi");
        // ignore: prefer-moving-to-variable
      } else if (move.n.abs() > 20) {
        story = player.t(" si è dato da fare", " si è data da fare");
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
      } else if (time > 20) {
        story += " in tempi astronomici";
      }
      _playerStories[playerIndex] = story;
      _playerNicknames[playerIndex] =
          // ignore: prefer-moving-to-variable
          smorfia[move.n.abs() % smorfia.length];
    }
  }

  @override
  void initOutcome() {
    var textTheme = Theme.of(context).textTheme;
    var widgets = <Widget>[];
    for (var playerIndex in TurnAware.turns) {
      var player = players[playerIndex];
      widgets.add(
        PlayerPerformance(
          player,
          primaryText: getMove(player).n.toString(),
          secondaryText: _playerNicknames[playerIndex],
        ),
      );
      widgets.add(
        Text(
          _playerStories[playerIndex],
          textAlign: TextAlign.center,
          style: textTheme.headlineMedium,
        ),
      );
      widgets.add(const Gap());
    }

    outcomeWidget = ListView(
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

class ShotMove extends Move {
  final int n;

  ShotMove({required this.n});

  @override
  int getPointsFor(Player player, Iterable<RecordedMove> allMoves) => n;
}
