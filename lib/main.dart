import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/title_screen.dart';

void main() async {
  // ignore: avoid-ignoring-return-values
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  static final RouteObserver<ModalRoute> routeObserver =
      RouteObserver<ModalRoute>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guidi Tu',
      theme: ThemeData(
        colorSchemeSeed: Colors.purpleAccent,
        brightness: Brightness.dark,
        fontFamily: 'LexendDeca',
        useMaterial3: true,
      ),
      home: const TitleScreen(),
      navigatorObservers: [routeObserver],
    );
  }
}
