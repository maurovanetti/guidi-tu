import 'package:flutter/material.dart';

import '/common/common.dart';

final class L10n {
  late String _userSelectedLanguage;

  String get userSelectedLanguage => _userSelectedLanguage;

  bool get isLanguageSelected => _userSelectedLanguage.isNotEmpty;

  // ignore: prefer-static-class
  List<LocalizationsDelegate<dynamic>> get localizationsDelegates =>
      AppLocalizations.localizationsDelegates;

// ignore: prefer-static-class
  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  set userSelectedLanguage(String language) {
    _userSelectedLanguage = language;
    db.set(Persistence.languageKey, language);
  }

  static final L10n _instance = L10n._internal();

  factory L10n() => _instance;

  L10n._internal() {
    _userSelectedLanguage = db.getString(Persistence.languageKey);
  }

  Locale get currentLocale {
    if (_userSelectedLanguage.isNotEmpty) {
      return Locale(_userSelectedLanguage);
    }
    return supportedLocales.first;
  }

  dynamic select({dynamic en, dynamic it}) {
    switch (_userSelectedLanguage) {
      case 'it':
        return it;
      case 'en':
      default:
        return en;
    }
  }
}
