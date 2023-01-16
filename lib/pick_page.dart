import 'package:flutter/material.dart';

import 'common/custom_fab.dart';
import 'common/navigation.dart';

class PickPage extends StatefulWidget {
  const PickPage({super.key});

  @override
  State<PickPage> createState() => _PickPageState();
}

class _PickPageState extends State<PickPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estrazione del minigioco'),
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
        onPressed: Navigation.replaceLast(context, () => const PickPage()).go,
        tooltip: 'Inizio',
        icon: Icons.play_arrow_rounded,
      ),
    );
  }
}
