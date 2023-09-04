import 'package:flutter/material.dart';

class ChallengeScoresScreen extends StatefulWidget {
  const ChallengeScoresScreen({super.key});

  @override
  ChallengeScoresScreenState createState() => ChallengeScoresScreenState();
}

class ChallengeScoresScreenState extends State<ChallengeScoresScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Punteggi'),
      ),
      body: const Center(
        child: Text('Punteggi'),
      ),
    );
  }
}
