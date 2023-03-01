import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/common/config.dart';
import '/common/custom_button.dart';
import '/common/custom_fab.dart';
import '/common/gap.dart';
import '/common/gender.dart';
import '/common/navigation.dart';
import '/common/player.dart';
import '/common/team_aware.dart';
import '/common/tracked_state.dart';
import '/common/widget_keys.dart';
import '/common/with_bubbles.dart';
import 'common/style_guide.dart';
import 'pick_page.dart';

const duplicatesWarning =
    "Alcuni nomi sono uguali tra loro, per favore cambiali.";

const addPlayersWarning = "Aggiungi almeno 2 partecipanti per favore.";

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends TrackedState<TeamPage> with Gendered, TeamAware {
  bool _loading = true;

  @override
  initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await retrieveTeam();
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
  }

  Iterable<PlayerButton> _buildNewPlayers() {
    var newPlayers = <PlayerButton>[];
    for (var player in players) {
      debugPrint("Player $player");
      newPlayers.add(PlayerButton(
        player,
        onEdit: () {
          _editPlayer(player);
        },
        onRemove: () {
          _removePlayer(player);
        },
      ));
    }
    return newPlayers;
  }

  void _editPlayer(Player player) async {
    debugPrint("Editing player $player");
    var editedPlayer = await showDialog<Player>(
      context: context,
      builder: (context) => PlayerDialog(player),
    );
    debugPrint("Edited player $editedPlayer");
    if (editedPlayer != null && mounted) {
      setState(() {
        players[players.indexOf(player)] = editedPlayer;
      });
    }
  }

  void _addNewPlayer() {
    debugPrint("Adding new player");
    Player newPlayer;
    newPlayer = players.length % 2 == 0
        ? Player(players.length, 'NUOVO', male)
        : Player(players.length, 'NUOVA', female);
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
      body: WithSquares(
        child: ListView(
          padding: StyleGuide.widePadding,
          children: _loading
              ? []
              : [
                  if (players.isNotEmpty)
                    const Text("Clicca sui nomi per modificarli:"),
                  ..._buildNewPlayers(),
                  if (players.length < maxPlayers)
                    CustomButton(
                        key: addPlayerWidgetKey,
                        important: false,
                        onPressed: _addNewPlayer,
                        text: "Aggiungi partecipante"),
                  if (hasDuplicates)
                    const Text(duplicatesWarning,
                        style: TextStyle(color: Colors.red)),
                  if (players.length < 2)
                    const Text(addPlayersWarning,
                        style: TextStyle(color: Colors.red)),
                ],
        ),
      ),
      floatingActionButton: players.length < 2
          ? null
          : CustomFloatingActionButton(
              key: toPickWidgetKey,
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
      Navigation.push(context, () => const PickPage()).go();
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
      key: editPlayerWidgetKey,
      title: const Text('Modifica partecipante'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Edit name
            TextField(
              key: editPlayerNameWidgetKey,
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
              key: setFemininePlayerWidgetKey,
              title: const Text('Chiamala «giocatrice»'),
              leading: Radio<Gender>(
                value: female,
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
            ),
            ListTile(
              key: setMasculinePlayerWidgetKey,
              title: const Text('Chiamalo «giocatore»'),
              leading: Radio<Gender>(
                value: male,
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          key: cancelEditPlayerWidgetKey,
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Annulla'),
        ),
        OutlinedButton(
          key: submitEditPlayerWidgetKey,
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

class UpperCaseTextFormatter extends TextInputFormatter {
  final int maxLength;

  UpperCaseTextFormatter(this.maxLength);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.length > maxLength) {
      return oldValue;
    }
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
      composing: newValue.composing,
    );
  }
}
