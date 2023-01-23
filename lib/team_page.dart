import 'package:flutter/material.dart';

import 'common/custom_fab.dart';
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
      newPlayers.add(NewPlayer(key: ValueKey(player.id), player, onRemove: () {
        debugPrint("Removing player ${player.name} (${player.id})");
        setState(() {
          _players.remove(player);
        });
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

class NewPlayer extends StatefulWidget {
  final Player initialPlayerData;
  final VoidCallback onRemove;
  const NewPlayer(this.initialPlayerData, {super.key, required this.onRemove});

  @override
  State<NewPlayer> createState() => _NewPlayerState();
}

class _NewPlayerState extends State<NewPlayer> {
  late Player player;

  @override
  void initState() {
    player = widget.initialPlayerData;
    super.initState();
  }

  @override
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
        onPressed: () {},
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
              onPressed: widget.onRemove,
            ),
          ],
        ),
      ),
    );
  }
}
