import 'package:flutter/material.dart';

abstract class Awards extends StatefulWidget {
  const Awards({super.key});

  @override
  AwardsState createState() => AwardsState();
}

class AwardsState extends State<Awards> {
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
    );
  }
}