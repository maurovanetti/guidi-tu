// This version of the app is in Italian only.
// ignore_for_file: avoid-non-ascii-symbols

import 'dart:async';

import 'package:flutter/material.dart';

import '/common/common.dart';
import 'pick_screen.dart';

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  static const duplicatesWarning =
      "Alcuni nomi sono uguali tra loro, per favore cambiali.";
  static const addPlayersWarning = "Aggiungi almeno 2 partecipanti per favore.";

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends TrackedState<TeamScreen>
    with Gendered, TeamAware {
  bool _loading = true;

  late final _defaultPlayers = [
    "ROBI",
    "ALE",
    "GIO",
    "FEDE",
    "SIMO",
    "VALE",
    "MICHI",
  ];

  @override
  initState() {
    super.initState();
    _defaultPlayers.shuffle();
    Delay.atNextFrame(() {
      retrieveTeam();
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  void _editPlayer(Player player) async {
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

  void _addNewPlayer() {
    debugPrint("Adding new player");
    Player newPlayer = Player(
      players.length,
      _defaultPlayers[players.length],
      Gender.neuter,
    );
    setState(() {
      players.add(newPlayer);
    });
    _editPlayer(newPlayer);
  }

  void _removePlayer(Player player) {
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

  void _showDuplicatesAlert() {
    unawaited(showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nomi duplicati"),
        content: const Text(TeamScreen.duplicatesWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    ));
  }

  void _proceedToPickPage() {
    storeTeam();
    if (mounted) {
      Navigation.push(context, () => const PickScreen()).go();
    }
  }

  bool _hasDuplicates() {
    var names = players.map((player) => player.name);
    return names.toSet().length != names.length;
  }

  @override
  Widget build(BuildContext context) {
    bool hasDuplicates = _hasDuplicates();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registra i partecipanti'),
      ),
      body: WithBubbles(
        child: ListView(
          padding: StyleGuide.widePadding,
          children: _loading
              ? []
              : [
                  if (players.isNotEmpty)
                    const Text("Clicca sui nomi per modificarli:"),
                  ...players.map((player) => PlayerButton(
                        player,
                        onEdit: _editPlayer,
                        onRemove: _removePlayer,
                      )),
                  if (players.length < Config.maxPlayers)
                    CustomButton(
                      key: WidgetKeys.addPlayer,
                      important: false,
                      onPressed: _addNewPlayer,
                      text: "Aggiungi partecipante",
                    ),
                  if (hasDuplicates)
                    const Text(
                      TeamScreen.duplicatesWarning,
                      style: TextStyle(color: Colors.red),
                    ),
                  if (players.length < 2)
                    const Text(
                      TeamScreen.addPlayersWarning,
                      style: TextStyle(color: Colors.red),
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
                  // ignore: avoid-nested-conditional-expressions
                  hasDuplicates ? _showDuplicatesAlert : _proceedToPickPage,
              tooltip: 'Pronti',
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

class PlayerDialogState extends State<PlayerDialog> {
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

  void _updateReadyToConfirm(String name) {
    setState(() {
      _setReadyToConfirm(name);
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
      title: const Text('Modifica partecipante'),
      content: Column(
        children: [
          // Edit name
          PlayerNameField(
            key: WidgetKeys.editPlayerName,
            controller: _nameController,
            themeData: Theme.of(context),
            onChanged: _updateReadyToConfirm,
          ),
          if (widget.editGender) ...[
            const Gap(),
            // Edit gender
            ListTile(
              key: WidgetKeys.setFemininePlayer,
              title: const Text('Chiamala «giocatrice»'),
              leading: Radio<Gender>(
                value: Gender.female,
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
            ),
            ListTile(
              key: WidgetKeys.setMasculinePlayer,
              title: const Text('Chiamalo «giocatore»'),
              leading: Radio<Gender>(
                value: Gender.male,
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
            ),
            ListTile(
              key: WidgetKeys.setNeutralPlayer,
              title: const Text('Nessuna preferenza'),
              leading: Radio<Gender>(
                value: Gender.neuter,
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          key: WidgetKeys.cancelEditPlayer,
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Annulla'),
        ),
        OutlinedButton(
          key: WidgetKeys.submitEditPlayer,
          onPressed: _readyToConfirm
              ? () => Navigator.of(context)
                  .pop(Player(_player.id, _nameController.text, _gender))
              : null,
          child: const Text('Conferma'),
        ),
      ],
    );
  }
}
