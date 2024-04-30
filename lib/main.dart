import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'common/common.dart';
import 'screens/title_screen.dart';

void main() async {
  // ignore: avoid-ignoring-return-values
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initializeDateFormatting(I18n.locale);
  await Persistence.init();
  runApp(kIsWeb ? const WebApp() : const App());
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

class WebApp extends StatelessWidget {
  const WebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterWebFrame(
      builder: (_) => const App(),
      // ignore: no-magic-number
      maximumSize: const Size(600, 800),
      backgroundColor: Colors.black,
    );
  }
}
