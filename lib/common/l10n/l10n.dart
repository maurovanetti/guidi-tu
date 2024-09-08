import 'package:flutter/material.dart';

import '/common/common.dart';

final class L10n {
  late String _userSelectedLanguage;

  static final _instance = L10n._internal();

  String get userSelectedLanguage => _userSelectedLanguage;

  bool get isLanguageSelected => _userSelectedLanguage.isNotEmpty;

  List<LocalizationsDelegate> get localizationsDelegates =>
      AppLocalizations.localizationsDelegates;

  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;

  Locale get currentLocale {
    return _userSelectedLanguage.isNotEmpty
        ? Locale(_userSelectedLanguage)
        : supportedLocales.first;
  }

  set userSelectedLanguage(String value) {
    _userSelectedLanguage = value;
    db.set(Persistence.languageKey, value);
  }

  factory L10n() => _instance;

  L10n._internal() {
    _userSelectedLanguage = db.getString(Persistence.languageKey);
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
