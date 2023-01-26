import 'package:flutter/material.dart';

import '../common/team_aware.dart';
import '/common/custom_fab.dart';
import '/common/navigation.dart';
import '/home_page.dart';

class PlacementScreen extends StatefulWidget {
  const PlacementScreen({super.key});

  @override
  PlacementScreenState createState() => PlacementScreenState();
}

class PlacementScreenState extends State<PlacementScreen> with TeamAware {

  Future<void> _endGame() async {
    Navigation.replaceAll(context, () => const HomePage()).go();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Risultato"),
        ),
        body: ListView(
          shrinkWrap: true,
          children: const [
            Text("Roba da fare"),
          ],
        ),
        floatingActionButton: CustomFloatingActionButton(
          tooltip: "Inizio",
          icon: Icons.stop_rounded,
          onPressed: _endGame,
        )
    );
  }
}
