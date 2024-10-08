import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import 'common.dart';

class Player with Gendered {
  int id;
  String name;

  static final none = NoPlayer._internal();

  static const drunkPlayerId = 4;
  static const soberPlayerId = 2;

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

  Color get colorNotBlack {
    var color = this.color;
    return color == Colors.black ? Colors.white : color;
  }

  Color get foreground => color.brighten(_brightening);

  Color get background => color.darken(_darkening);

  String get iconName => _icons[id % _icons.length];

  Player(this.id, this.name, gender) {
    this.gender = gender;
  }

  Player.fromJson(this.id, Map<String, dynamic> json) : name = json['name'] {
    gender = Gender.fromLetter(json['gender'].toString());
  }

  Player.forChallenge(this.name, {required bool sober})
      : id = sober ? soberPlayerId : drunkPlayerId {
    gender = Gender.neuter;
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender.letter,
      'name': name,
    };
  }

  @override
  String toString() => "$id:$name";

  String iconAssetPath(PlayerIconVariant variant) =>
      'players/${variant.name}/$iconName.png';
}

class NoPlayer extends Player {
  @override
  get iconName => '';

  @override
  get background => Colors.transparent;

  @override
  get foreground => Colors.transparent;

  NoPlayer._internal() : super(-1, '', Gender.neuter);
}

class PlayerButton extends StatelessWidget {
  const PlayerButton(
    this.player, {
    super.key,
    this.onEdit,
    this.onRemove,
  });

  static const _genderSymbolScale = 0.8;

  final Player player;
  final OnPlayerAction? onRemove;
  final OnPlayerAction? onEdit;

  get textColor => player.foreground;

  TextStyle _textStyle(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge!.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          );

  void _handleEdit() {
    onEdit?.call(player);
  }

  void _handleRemove() {
    onRemove?.call(player);
  }

  @override
  Widget build(BuildContext context) {
    var style = _textStyle(context);
    return PlayerButtonStructure(
      player,
      onEdit: _handleEdit,
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
            icon: Icon(Icons.remove_circle, color: player.colorNotBlack),
            onPressed: _handleRemove,
          ),
        ],
      ),
    );
  }
}

class PlayerButtonStructure extends StatelessWidget {
  const PlayerButtonStructure(
    this.player, {
    required this.child,
    this.onEdit = _uselessClick,
    super.key,
  });

  // The useless click prevents the button from being disabled
  // ignore: prefer-getter-over-method
  static _uselessClick() {}

  final Player player;
  final Widget child;
  final VoidCallback onEdit;

  get buttonStyle => ElevatedButton.styleFrom(
        backgroundColor: player.background,
        shape: RoundedRectangleBorder(
          borderRadius: onEdit == _uselessClick
              ? BorderRadius.zero
              : StyleGuide.borderRadius,
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
  const PlayerIcon.black(this.player, {super.key})
      : variant = PlayerIconVariant.white,
        color = Colors.black;

  const PlayerIcon.white(this.player, {super.key})
      : variant = PlayerIconVariant.white,
        color = null;

  const PlayerIcon.color(this.player, {super.key})
      : variant = PlayerIconVariant.color,
        color = null;

  const PlayerIcon.inverted(this.player, {super.key})
      : variant = PlayerIconVariant.inverted,
        color = null;

  static const _imagesDir = 'assets/images/';
  final PlayerIconVariant variant;
  final Player player;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (player is NoPlayer) {
      return const SizedBox(
        width: StyleGuide.iconSize,
        height: StyleGuide.iconSize,
      );
    }
    // ignore: prefer-returning-conditional-expressions
    return Image(
      image: AssetImage(
        _imagesDir + player.iconAssetPath(variant),
      ),
      width: StyleGuide.iconSize,
      color: color,
      semanticLabel: player.name,
    );
  }
}

class PlayerTag extends PlayerButton {
  const PlayerTag(super.player, {super.key});

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
          Text(player.name.toUpperCase(), style: _textStyle(context)),
        ],
      ),
    );
  }
}

class PlayerPerformance extends PlayerButton {
  const PlayerPerformance(
    super.player, {
    required this.primaryText,
    this.secondaryText = '',
    super.key,
  });

  static const _secondaryTextScale = 0.7;

  final String primaryText;
  final String secondaryText;

  @override
  Widget build(BuildContext context) {
    var style = _textStyle(context);
    var horizontalGap = const Spacer();
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
            flex: 5,
            child: FittedText(primaryText, style: style),
          ),
          if (secondaryText.isNotEmpty) horizontalGap,
          if (secondaryText.isNotEmpty)
            Expanded(
              flex: 3,
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
  final AppLocalizations $;
  PlayerPlacement(Award award, {super.key, required this.$})
      : super(
          award.player,
          primaryText: award.score.displayedFirst($),
          secondaryText: award.score.displayedSecond($),
        );
}
