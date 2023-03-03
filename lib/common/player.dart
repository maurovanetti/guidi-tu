import 'package:flutter/material.dart';
import 'package:guidi_tu/common/style_guide.dart';

import 'fitted_text.dart';
import 'gap.dart';
import 'gender.dart';
import 'score_aware.dart';
import 'widget_keys.dart';

class Player with Gendered {
  int id;
  String name;

  // TODO Replace with proper icons
  // ignore_for_file: avoid-non-ascii-symbols
  static const _icons = [
    '🎹',
    '🎸',
    '🎷',
    '🎤',
    '🎻',
    '🥁',
    '🎺',
  ];

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

  String get icon => _icons[id % _icons.length];

  Player(this.id, this.name, gender) {
    this.gender = gender;
  }

  Player.fromJson(this.id, Map<String, dynamic> json) : name = json['name'] {
    gender = json['gender'] == Gender.male.letter ? Gender.male : Gender.female;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'gender': gender.letter,
    };
  }

  @override
  String toString() => "$id:$name";
}

class NoPlayer extends Player {
  @override
  get icon => '';

  @override
  get background => Colors.transparent;

  @override
  get foreground => Colors.transparent;

  NoPlayer() : super(0, '', Gender.neuter);
}

class PlayerButton extends StatelessWidget {
  static const _genderSymbolScale = 0.8;

  final Player player;
  final void Function(Player)? onRemove;
  final void Function(Player)? onEdit;

  const PlayerButton(this.player, {
    super.key,
    this.onEdit,
    this.onRemove,
  });

  get textColor => player.foreground;

  TextStyle textStyle(BuildContext context) =>
      Theme
          .of(context)
          .textTheme
          .headlineLarge!
          .copyWith(
        color: textColor,
        fontWeight: FontWeight.bold,
      );

  _edit() {
    onEdit?.call(player);
  }

  _remove() {
    onRemove?.call(player);
  }

  @override
  Widget build(BuildContext context) {
    var style = textStyle(context);
    return PlayerButtonStructure(
      player,
      onEdit: _edit,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _PlayerIcon(player),
          Row(
            children: [
              Text(player.name.toUpperCase(), style: style),
              const SizedBox(width: 10),
              Text(
                player.gender.symbol,
                style: style.copyWith(
                  fontSize: style.fontSize! * _genderSymbolScale,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.remove_circle, color: textColor),
            onPressed: _remove,
          ),
        ],
      ),
    );
  }
}

class PlayerButtonStructure extends StatelessWidget {
  // The useless click prevents the button from being disabled
  static _uselessClick() {}

  final Player player;
  final Widget child;
  final VoidCallback onEdit;

  const PlayerButtonStructure(this.player, {
    required this.child,
    this.onEdit = _uselessClick,
    super.key,
  });

  get buttonStyle =>
      ElevatedButton.styleFrom(
        backgroundColor: player.background,
        shape: const RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(Radius.circular(StyleGuide.borderRadius)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: WidgetKeys.playerButton(player),
      padding: StyleGuide.narrowPadding,
      child: ElevatedButton(
        onPressed: onEdit,
        style: buttonStyle,
        child: child,
      ),
    );
  }
}

class _PlayerIcon extends StatelessWidget {
  final Player player;

  const _PlayerIcon(this.player);

  @override
  Widget build(BuildContext context) {
    return Text(player.icon, style: Theme
        .of(context)
        .textTheme
        .headlineSmall);
  }
}

class PlayerTag extends PlayerButton {
  const PlayerTag(Player player, {super.key}) : super(player);

  @override
  Widget build(BuildContext context) {
    return PlayerButtonStructure(
      player,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _PlayerIcon(player),
          const Gap(),
          Text(player.name.toUpperCase(), style: textStyle(context)),
        ],
      ),
    );
  }
}

class PlayerPerformance extends PlayerButton {
  static const _secondaryTextScale = 0.7;

  final String primaryText;
  final String secondaryText;

  const PlayerPerformance(Player player, {
    required this.primaryText,
    this.secondaryText = '',
    super.key,
  }) : super(player);

  @override
  Widget build(BuildContext context) {
    var style = textStyle(context);
    var horizontalGap = const Spacer(flex: 1);
    return PlayerButtonStructure(
      player,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: _PlayerIcon(player),
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
                style: style.copyWith(
                  fontSize: style.fontSize! * _secondaryTextScale,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PlayerPlacement extends PlayerPerformance {
  PlayerPlacement(Award award, {super.key})
      : super(
    award.player,
    primaryText: award.score.pointsMatter
        ? award.score.formattedPoints
        : award.score.formattedTime,
    secondaryText:
    award.score.pointsMatter ? award.score.formattedTime : '',
  );
}
