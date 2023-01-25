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

  @override
  get icon => '';

  @override
  get background => Colors.transparent;

  @override
  get foreground => Colors.transparent;

  @override
  get genderSymbol => '';
}

class PlayerButton extends StatelessWidget {
  final Player player;
  final VoidCallback? onRemove;
  final VoidCallback? onEdit;

  const PlayerButton(this.player,
      {super.key, required this.onEdit, required this.onRemove});

  get textColor => player.foreground;

  TextStyle? textStyle(BuildContext context) => Theme.of(context)
      .textTheme
      .headlineLarge
      ?.copyWith(color: textColor, fontWeight: FontWeight.bold);

  get buttonStyle => ElevatedButton.styleFrom(
      backgroundColor: player.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ));

  Widget buildIcon(BuildContext context) {
    return Text(player.icon, style: Theme.of(context).textTheme.headlineSmall);
  }

  Row buildContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildIcon(context),
        Text("${player.name.toUpperCase()} ${player.genderSymbol}",
            style: textStyle(context)),
        IconButton(
          icon: Icon(Icons.remove_circle, color: textColor),
          onPressed: onRemove,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
        onPressed: onEdit,
        style: buttonStyle,
        child: buildContent(context),
      ),
    );
  }
}

class PlayerTag extends PlayerButton {
  PlayerTag(Player player, {super.key})
      : super(player, onEdit: () {}, onRemove: () {});

  @override
  buildContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildIcon(context),
        const Gap(),
        Text(player.name.toUpperCase(), style: textStyle(context)),
      ],
    );
  }
}
