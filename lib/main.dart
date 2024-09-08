import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'common/common.dart';
import 'screens/language_screen.dart';
import 'screens/title_screen.dart';

void main() async {
  // ignore: avoid-ignoring-return-values
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await initializeDateFormatting(I18n.locale);
  await Persistence.init();
  runApp(kIsWeb ? const WebApp() : const App());
}

class App extends StatefulWidget {
  const App({super.key});

  static final routeObserver = RouteObserver<ModalRoute>();

  @override
  AppState createState() => AppState();
}

class AppState extends State<StatefulWidget> with Localized {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: StyleGuide.themeData,
      home: L10n().isLanguageSelected
          ? const TitleScreen()
          : const LanguageScreen(),
      navigatorObservers: [App.routeObserver],
      localizationsDelegates: L10n().localizationsDelegates,
      supportedLocales: L10n().supportedLocales,
      builder: (innerContext, child) {
        return Localizations.override(
          context: innerContext,
          locale: L10n().currentLocale,
          child: child!,
        );
      },
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
