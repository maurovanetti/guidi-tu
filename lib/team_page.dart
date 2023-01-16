import 'package:flutter/material.dart';

import 'common/custom_fab.dart';
import 'common/navigation.dart';
import 'pick_page.dart';

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registra i partecipanti'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Roba da fare"),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: Navigation.replaceAll(context, () => const PickPage()).go,
        tooltip: 'Pronti',
        icon: Icons.check_circle_rounded,
      ),
    );
  }
}
