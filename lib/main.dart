import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guidi Tu',
      theme: ThemeData(
        colorSchemeSeed: Colors.purpleAccent,
        brightness: Brightness.dark,
        fontFamily: 'Signika',
      ),
      home: const HomePage(title: 'Guidi Tu'),
    );
  }
}
