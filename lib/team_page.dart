import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common/custom_fab.dart';
import 'common/gap.dart';
import 'common/navigation.dart';
import 'common/player.dart';
import 'pick_page.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  List<Player> _players = [
    Player(0, 'FEDE', Gender.f),
    Player(1, 'ROBY', Gender.m),
    Player(2, 'NADIA', Gender.f),
  ];

  Iterable<NewPlayer> _buildNewPlayers() {
    var newPlayers = <NewPlayer>[];
    for (var player in _players) {
      debugPrint("Building player $player");
      newPlayers.add(NewPlayer(player, onEdit: () async {
        debugPrint("Editing player $player");
        var editedPlayer = await showDialog<Player>(
            context: context, builder: (context) => PlayerDialog(player));
        debugPrint("Edited player $editedPlayer");
        if (editedPlayer != null) {
          setState(() {
            _players[_players.indexOf(player)] = editedPlayer;
          });
        }
      }, onRemove: () {
        debugPrint("Removing player $player");
        setState(() {
          _players.remove(player);
        });
        for (var i = 0; i < _players.length; i++) {
          setState(() {
            _players[i].id = i;
          });
        }
      }));
    }
    return newPlayers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registra i partecipanti'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: [
          Text("Clicca sui nomi per modificarli:"),
          ..._buildNewPlayers(),
          ElevatedButton(onPressed: null, child: Text("Aggiungi partecipante"))
        ],
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: Navigation.replaceAll(context, () => const PickPage()).go,
        tooltip: 'Pronti',
        icon: Icons.check_circle_rounded,
      ),
    );
  }
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

  @override
  void initState() {
    _player = widget.player;
    _nameController = TextEditingController(text: _player.name);
    _gender = _player.gender;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifica partecipante'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Edit name
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(counterText: 'max 5 lettere'),
            inputFormatters: [UpperCaseTextFormatter(5)],
            textCapitalization: TextCapitalization.characters,
            style: Theme.of(context).textTheme.headlineLarge,
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
            onPressed: () => Navigator.of(context)
                .pop(Player(_player.id, _nameController.text, _gender)),
            child: const Text('Conferma')),
      ],
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  final int maxLength;

  UpperCaseTextFormatter(this.maxLength);

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

class NewPlayer extends StatelessWidget {
  final Player player;
  final VoidCallback onRemove;
  final VoidCallback onEdit;
  const NewPlayer(this.player,
      {super.key, required this.onEdit, required this.onRemove});

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
