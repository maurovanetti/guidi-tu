import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common/common.dart';
import 'screens/title_screen.dart';

void main() async {
  // ignore: avoid-ignoring-return-values
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  static final routeObserver = RouteObserver<ModalRoute>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guidi Tu',
      theme: StyleGuide.themeData,
      home: const TitleScreen(),
      navigatorObservers: [routeObserver],
    );
  }
}
