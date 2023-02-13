import 'package:flutter/material.dart';

import 'fitted_text.dart';
import 'gap.dart';
import 'gender.dart';
import 'score_aware.dart';

class Player with Gendered {
  int id;
  String name;

  Player(this.id, this.name, gender) {
    this.gender = gender;
  }

  Player.fromJson(this.id, Map<String, dynamic> json) : name = json['name'] {
    gender = json['gender'] == male.letter ? male : female;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender.letter,
    };
  }

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
}

class NoPlayer extends Player {
  NoPlayer() : super(0, '', neuter);

  @override
  get icon => '';

  @override
  get background => Colors.transparent;

  @override
  get foreground => Colors.transparent;
}

class PlayerButton extends StatelessWidget {
  final Player player;
  final VoidCallback? onRemove;
  final VoidCallback? onEdit;

  const PlayerButton(this.player,
      {super.key, required this.onEdit, required this.onRemove});

  get textColor => player.foreground;

  TextStyle textStyle(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge!.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          );

  get buttonStyle => ElevatedButton.styleFrom(
      backgroundColor: player.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ));

  Widget buildIcon(BuildContext context) {
    return Text(player.icon, style: Theme.of(context).textTheme.headlineSmall);
  }

  Row buildContent(BuildContext context) {
    var style = textStyle(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildIcon(context),
        Row(
          children: [
            Text(player.name.toUpperCase(), style: style),
            const SizedBox(width: 10),
            Text(
              player.gender.symbol,
              style: style.copyWith(fontSize: style.fontSize! * 0.8),
            ),
          ],
        ),
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
  Row buildContent(BuildContext context) {
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

class PlayerPerformance extends PlayerButton {
  final String primaryText;
  final String secondaryText;

  PlayerPerformance(Player player,
      {required this.primaryText, this.secondaryText = '', super.key})
      : super(player, onEdit: () {}, onRemove: () {});

  @override
  Row buildContent(BuildContext context) {
    var style = textStyle(context);
    var horizontalGap = const Spacer(flex: 1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: buildIcon(context),
        ),
        horizontalGap,
        Expanded(
          flex: 8,
          child: FittedText(player.name.toUpperCase(), style: style),
        ),
        horizontalGap,
        Expanded(
          flex: 4,
          child: FittedText(primaryText, style: style),
        ),
        if (secondaryText.isNotEmpty) horizontalGap,
        if (secondaryText.isNotEmpty)
          Expanded(
            flex: 4,
            child: FittedText(
              secondaryText,
              style: style.copyWith(fontSize: style.fontSize! * 0.7),
            ),
          ),
      ],
    );
  }
}

class PlayerPlacement extends PlayerPerformance {
  PlayerPlacement(Award award, {super.key})
      : super(award.player,
            primaryText: award.score.pointsMatter
                ? award.score.formattedPoints
                : award.score.formattedTime,
            secondaryText:
                award.score.pointsMatter ? award.score.formattedTime : '');
}
