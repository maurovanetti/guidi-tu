import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import 'fitted_text.dart';
import 'gap.dart';
import 'gender.dart';
import 'score_aware.dart';
import 'style_guide.dart';
import 'widget_keys.dart';

class Player with Gendered {
  int id;
  String name;

  static const _icons = [
    'player_1',
    'player_2',
    'player_3',
    'player_4',
    'player_5',
    'player_6',
    'player_7',
    'player_8', // not used
  ];

  static const _brightening = 0.5;
  static const _darkening = 0.7;
  static final _palette = [
    const Color.fromARGB(255, 0xff, 0xd4, 0x02),
    const Color.fromARGB(255, 0xe0, 0x3a, 0x3b),
    const Color.fromARGB(255, 0x2b, 0xd7, 0x86),
    const Color.fromARGB(255, 0x0b, 0xc3, 0xff),
    const Color.fromARGB(255, 0xcb, 0x54, 0xe8),
    const Color.fromARGB(255, 0x00, 0x00, 0x00),
    const Color.fromARGB(255, 0x48, 0x27, 0xb6),
    const Color.fromARGB(255, 0xdd, 0xdd, 0xdd),
  ];

  Color get color => _palette[id % _palette.length];

  Color get foreground => color.brighten(_brightening);

  Color get background => color.darken(_darkening);

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

  const PlayerButton(
    this.player, {
    super.key,
    this.onEdit,
    this.onRemove,
  });

  get textColor => player.foreground;

  TextStyle textStyle(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge!.copyWith(
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
          PlayerIcon.color(player),
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
            icon: Icon(Icons.remove_circle, color: player.color),
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

  const PlayerButtonStructure(
    this.player, {
    required this.child,
    this.onEdit = _uselessClick,
    super.key,
  });

  get buttonStyle => ElevatedButton.styleFrom(
        backgroundColor: player.background,
        shape: RoundedRectangleBorder(
          borderRadius: onEdit == _uselessClick
              ? BorderRadius.zero
              : const BorderRadius.all(
                  Radius.circular(StyleGuide.borderRadius),
                ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: WidgetKeys.playerButton(player),
      padding: StyleGuide.stripePadding,
      child: ElevatedButton(
        onPressed: onEdit,
        style: buttonStyle,
        child: child,
      ),
    );
  }
}

enum PlayerIconVariant { white, color, inverted }

class PlayerIcon extends StatelessWidget {
  final PlayerIconVariant variant;
  final Player player;

  const PlayerIcon.white(this.player, {super.key})
      : variant = PlayerIconVariant.white;
  const PlayerIcon.color(this.player, {super.key})
      : variant = PlayerIconVariant.color;
  const PlayerIcon.inverted(this.player, {super.key})
      : variant = PlayerIconVariant.inverted;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: AssetImage(
        'assets/images/players/${variant.name}/${player.icon}.png',
      ),
      width: StyleGuide.iconSize,
    );
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
          PlayerIcon.color(player),
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

  const PlayerPerformance(
    Player player, {
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
            child: PlayerIcon.color(player),
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
          primaryText: award.score.displayedFirst,
          secondaryText: award.score.displayedSecond,
        );
}
