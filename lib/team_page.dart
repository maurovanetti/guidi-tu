import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common/config.dart';
import 'common/custom_fab.dart';
import 'common/gap.dart';
import 'common/navigation.dart';
import 'common/player.dart';
import 'common/team_aware.dart';
import 'pick_page.dart';

const duplicatesWarning =
    "Alcuni nomi sono uguali tra loro, per favore cambiali.";

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> with TeamAware {
  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await retrieveTeam();
      setState(() {});
    });
  }

  Iterable<PlayerButton> _buildNewPlayers() {
    var newPlayers = <PlayerButton>[];
    for (var player in players) {
      debugPrint("Player $player");
      newPlayers.add(PlayerButton(player, onEdit: () {
        _editPlayer(player);
      }, onRemove: () {
        _removePlayer(player);
      }));
    }
    return newPlayers;
  }

  void _editPlayer(Player player) async {
    debugPrint("Editing player $player");
    var editedPlayer = await showDialog<Player>(
        context: context, builder: (context) => PlayerDialog(player));
    debugPrint("Edited player $editedPlayer");
    if (editedPlayer != null) {
      setState(() {
        players[players.indexOf(player)] = editedPlayer;
      });
    }
  }

  void _addNewPlayer() {
    debugPrint("Adding new player");
    Player newPlayer;
    if (players.length % 2 == 0) {
      newPlayer = Player(players.length, 'NUOVO', Gender.m);
    } else {
      newPlayer = Player(players.length, 'NUOVA', Gender.f);
    }
    setState(() {
      players.add(newPlayer);
    });
    _editPlayer(newPlayer);
  }

  void _removePlayer(Player player) {
    debugPrint("Removing player $player");
    setState(() {
      players.remove(player);
    });
    for (var i = 0; i < players.length; i++) {
      setState(() {
        players[i].id = i;
      });
    }
  }

  void _showDuplicatesAlert() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Nomi duplicati"),
              content: const Text(duplicatesWarning),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    bool hasDuplicates = _hasDuplicates(players);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registra i partecipanti'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          if (players.isNotEmpty)
            const Text("Clicca sui nomi per modificarli:"),
          ..._buildNewPlayers(),
          if (players.length < maxPlayers)
            ElevatedButton(
                onPressed: _addNewPlayer,
                child: const Text("Aggiungi partecipante")),
          if (hasDuplicates)
            const Text(duplicatesWarning, style: TextStyle(color: Colors.red)),
        ],
      ),
      floatingActionButton: players.length < 2
          ? null
          : CustomFloatingActionButton(
              onPressed:
                  hasDuplicates ? _showDuplicatesAlert : _proceedToPickPage,
              tooltip: 'Pronti',
              icon: Icons.check_circle_rounded,
            ),
    );
  }

  Future<void> _proceedToPickPage() async {
    await storeTeam();
    if (mounted) {
      Navigation.replaceAll(context, () => const PickPage()).go();
    }
  }
}

bool _hasDuplicates(List<Player> players) {
  var names = players.map((player) => player.name);
  return names.toSet().length != names.length;
}

class PlayerDialog extends StatefulWidget {
  final Player player;

  const PlayerDialog(this.player, {super.key});

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
    _player = widget.player;
    _nameController = TextEditingController(text: _player.name);
    _gender = _player.gender;
    _checkReadyToConfirm(_player.name);
    super.initState();
  }

  void _checkReadyToConfirm(String name) {
    debugPrint("Checking if ready to confirm");
    setState(() {
      _readyToConfirm = name.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifica partecipante'),
      content: ListView(
        shrinkWrap: true,
        children: [
          // Edit name
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(counterText: 'max 5 lettere'),
            inputFormatters: [UpperCaseTextFormatter(5)],
            textCapitalization: TextCapitalization.characters,
            style: Theme.of(context).textTheme.headlineLarge,
            onChanged: _checkReadyToConfirm,
          ),
          const Gap(),
          // Edit gender
          ListTile(
            title: const Text('Chiamala «giocatrice»'),
            leading: Radio<Gender>(
                value: Gender.f,
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                }),
          ),
          ListTile(
            title: const Text('Chiamalo «giocatore»'),
            leading: Radio<Gender>(
                value: Gender.m,
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                }),
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text('Annulla')),
        TextButton(
            onPressed: _readyToConfirm
                ? () => Navigator.of(context)
                    .pop(Player(_player.id, _nameController.text, _gender))
                : null,
            child: const Text('Conferma')),
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  final int maxLength;

  UpperCaseTextFormatter(this.maxLength);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > maxLength) {
      return oldValue;
    }
    return TextEditingValue(
        text: newValue.text.toUpperCase(),
        selection: newValue.selection,
        composing: newValue.composing);
  }
}
