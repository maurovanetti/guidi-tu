import 'package:flutter/material.dart';

import 'gap.dart';

enum Gender {
  m,
  f,
}

class Player {
  int id;
  String name;
  Gender gender;

  Player(this.id, this.name, this.gender);

  Player.fromJson(this.id, dynamic json)
      : name = json['name'],
        gender = json['gender'] == Gender.m.name ? Gender.m : Gender.f;

  static const _icons = [
    '🎹',
    '🎸',
    '🎷',
    '🎤',
    '🎻',
    '🥁',
    '🎺',
  ];
  String get icon => _icons[id % _icons.length];

  String get genderSymbol {
    switch (gender) {
      case Gender.f:
        return "♀";
      case Gender.m:
        return "♂";
    }
  }

  static final _foregroundColors = [
    Colors.purple.shade900,
    Colors.pink.shade900,
    Colors.brown.shade900,
    Colors.indigo.shade900,
    Colors.green.shade900,
    Colors.black87,
    Colors.deepOrange.shade900,
  ];
  static final _backgroundColors = [
    Colors.purpleAccent.shade100,
    Colors.pinkAccent.shade100,
    Colors.brown.shade300,
    Colors.indigoAccent.shade100,
    Colors.greenAccent.shade100,
    Colors.grey.shade100,
    Colors.deepOrangeAccent.shade100,
  ];
  Color get background => _backgroundColors[id % _backgroundColors.length];
  Color get foreground => _foregroundColors[id % _foregroundColors.length];

  @override
  String toString() => "$id:$name";

  dynamic toJson() {
    return {
      'name': name,
      'gender': gender.name,
    };
  }

  String t(String masculine, String feminine) {
    switch (gender) {
      case Gender.m:
        return masculine;
      case Gender.f:
        return feminine;
    }
  }
}

class NoPlayer extends Player {
  NoPlayer() : super(0, '', Gender.m);

  get icon => '';
  get background => Colors.transparent;
  get foreground => Colors.transparent;
  get genderSymbol => '';
}

class PlayerButton extends StatelessWidget {
  final Player player;
  final VoidCallback onRemove;
  final VoidCallback onEdit;
  const PlayerButton(this.player,
      {super.key, required this.onEdit, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = ButtonStyle(
        backgroundColor: MaterialStateProperty.all(player.background));
    final textColor = player.foreground;
    final textStyle = theme.textTheme.headlineLarge
        ?.copyWith(color: textColor, fontWeight: FontWeight.bold);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
        onPressed: onEdit,
        style: buttonStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(player.icon, style: Theme.of(context).textTheme.headlineSmall),
            Text("${player.name.toUpperCase()} ${player.genderSymbol}",
                style: textStyle),
            IconButton(
              icon: Icon(Icons.remove_circle, color: textColor),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerTag extends StatelessWidget {
  final Player player;
  const PlayerTag(this.player, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = ButtonStyle(
        backgroundColor: MaterialStateProperty.all(player.background));
    final textColor = player.foreground;
    final textStyle = theme.textTheme.headlineLarge
        ?.copyWith(color: textColor, fontWeight: FontWeight.bold);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
        onPressed: null,
        style: buttonStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(player.icon, style: Theme.of(context).textTheme.headlineSmall),
            const Gap(),
            Text(player.name.toUpperCase(), style: textStyle),
          ],
        ),
      ),
    );
  }

  static PlayerTag noPlayerTag = PlayerTag(Player(-1, '', Gender.m));
}
