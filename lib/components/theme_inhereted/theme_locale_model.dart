import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';

class ThemeLocaleModel extends ChangeNotifier {
   ThemeLocaleModel({this.isLightTheme, this.locale, this.languageCode}) {
    if (languageCode != null) {
      locale = Locale.fromSubtags(languageCode: languageCode!);
    }
  }

  bool? isLightTheme;
  Locale? locale;
  String? languageCode;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void changeTheme(bool isLightTheme) {
    this.isLightTheme = isLightTheme;
    _prefs.then(
      (SharedPreferences prefs) {
        return prefs.setBool('isLightTheme', isLightTheme);
      },
    );
    notifyListeners();
  }

  void setLocale(Locale locale) {
    this.locale = locale;
    languageCode = locale.languageCode;
    _prefs.then(
      (SharedPreferences prefs) {
        return prefs.setString('localeLanguageCode', locale.languageCode);
      },
    );
    SLocale.load(locale);
    notifyListeners();
  }
}
