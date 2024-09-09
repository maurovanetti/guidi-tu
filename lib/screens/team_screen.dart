// This version of the app is in Italian only.
// ignore_for_file: avoid-non-ascii-symbols

import 'dart:async';

import 'package:flutter/material.dart';

import '/common/common.dart';
import 'pick_screen.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends TrackedState<TeamScreen>
    with Gendered, TeamAware {
  bool _loading = true;

  late final List<String> _defaultPlayers;

  @override
  initState() {
    super.initState();
    Delay.atNextFrame(() {
      retrieveTeam();
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  void _handleEditPlayer(Player player) async {
    debugPrint("Editing player $player");
    Player? editedPlayer = await showDialog<Player>(
      context: context,
      builder: (context) => PlayerDialog(player, editGender: true),
    );
    if (editedPlayer != null && mounted) {
      debugPrint("Edited player $editedPlayer");
      setState(() {
        players[players.indexOf(player)] = editedPlayer;
      });
    }
  }

  void _handleAddNewPlayer() {
    debugPrint("Adding new player");
    Player newPlayer = Player(
      players.length,
      _defaultPlayers[players.length],
      Gender.neuter,
    );
    setState(() {
      players.add(newPlayer);
    });
    _handleEditPlayer(newPlayer);
  }

  void _handleRemovePlayer(Player player) {
    debugPrint("Removing player $player from $players");
    setState(() {
      final removed = players.removeAt(player.id);
      assert(removed.name == player.name);
    });
    for (var i = 0; i < players.length; i++) {
      setState(() {
        players[i].id = i;
      });
    }
  }

  void _handleDuplicates() {
    unawaited(showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text($.duplicatesWarningTitle),
        content: Text($.duplicatesWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text($.ok),
          ),
        ],
      ),
    ));
  }

  void _handleProceedToPickPage() {
    storeTeam();
    if (mounted) {
      Navigation.push(context, () => const PickScreen()).go();
    }
  }

  // ignore: prefer-getter-over-method
  bool _hasDuplicates() {
    var names = players.map((player) => player.name);
    return names.toSet().length != names.length;
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _defaultPlayers = $.defaultPlayerNames.split(',')..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    bool hasDuplicates = _hasDuplicates();
    return Scaffold(
      appBar: AppBar(
        title: Text($.registerPlayers),
      ),
      body: WithBubbles(
        child: ListView(
          padding: StyleGuide.widePadding,
          children: _loading
              ? []
              : [
                  if (players.isNotEmpty) Text($.clickNamesToEdit),
                  ...players.map((player) => PlayerButton(
                        player,
                        onEdit: _handleEditPlayer,
                        onRemove: _handleRemovePlayer,
                      )),
                  if (players.length < Config.maxPlayers)
                    CustomButton(
                      key: WidgetKeys.addPlayer,
                      important: false,
                      onPressed: _handleAddNewPlayer,
                      text: $.addPlayer,
                    ),
                  if (hasDuplicates)
                    Text(
                      $.duplicatesWarning,
                      style: const TextStyle(color: Colors.red),
                    ),
                  if (players.length < 2)
                    Text(
                      $.addPlayersWarning,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SafeMarginForCustomFloatingActionButton(),
                ],
        ),
      ),
      floatingActionButton: players.length < 2
          ? null
          : CustomFloatingActionButton(
              key: WidgetKeys.toPick,
              onPressed:
                  hasDuplicates ? _handleDuplicates : _handleProceedToPickPage,
              tooltip: $.playersReady(gender.letter),
              icon: Icons.check_circle_rounded,
            ),
    );
  }
}

class PlayerDialog extends StatefulWidget {
  const PlayerDialog(this.player, {super.key, required this.editGender});

  final Player player;
  final bool editGender;

  @override
  State<PlayerDialog> createState() => PlayerDialogState();
}

class PlayerDialogState extends State<PlayerDialog> with Localized {
  late Player _player;
  late final TextEditingController _nameController;
  late Gender _gender;
  late bool _readyToConfirm;

  @override
  void initState() {
    super.initState();
    _player = widget.player;
    _nameController = TextEditingController(text: _player.name);
    _gender = _player.gender;
    _setReadyToConfirm(_player.name);
  }

  void _setReadyToConfirm(String name) {
    _readyToConfirm = name.isNotEmpty;
  }

  void _handleReadyToConfirm(String name) {
    setState(() {
      _setReadyToConfirm(name);
    });
  }

  void _handleGenderChange(Gender? value) {
    setState(() {
      _gender = value!;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      key: WidgetKeys.editPlayer,
      title: Text($.editPlayer),
      content: Column(
        children: [
          // Edit name
          PlayerNameField(
            key: WidgetKeys.editPlayerName,
            controller: _nameController,
            themeData: Theme.of(context),
            onChanged: _handleReadyToConfirm,
            $: get$(context),
          ),
          if (widget.editGender) ...[
            const Gap(),
            // Edit gender
            ListTile(
              key: WidgetKeys.setFemininePlayer,
              title: Text($.setFemininePlayer),
              leading: Radio<Gender>(
                value: Gender.female,
                groupValue: _gender,
                onChanged: _handleGenderChange,
              ),
            ),
            ListTile(
              key: WidgetKeys.setMasculinePlayer,
              title: Text($.setMasculinePlayer),
              leading: Radio<Gender>(
                value: Gender.male,
                groupValue: _gender,
                onChanged: _handleGenderChange,
              ),
            ),
            ListTile(
              key: WidgetKeys.setNeutralPlayer,
              title: Text($.setNeutralPlayer),
              leading: Radio<Gender>(
                value: Gender.neuter,
                groupValue: _gender,
                onChanged: _handleGenderChange,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          key: WidgetKeys.cancelEditPlayer,
          onPressed: () => Navigator.of(context).pop(),
          child: Text($.cancel),
        ),
        OutlinedButton(
          key: WidgetKeys.submitEditPlayer,
          onPressed: _readyToConfirm
              ? () => Navigator.of(context)
                  .pop(Player(_player.id, _nameController.text, _gender))
              : null,
          child: Text($.confirm),
        ),
      ],
    );
  }
}
