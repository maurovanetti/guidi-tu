import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const App());
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

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
        useMaterial3: true,
      ),
      home: const HomePage(),
      navigatorObservers: [routeObserver],
    );
  }
}
