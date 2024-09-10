import 'dart:io';

import 'package:bracket_card_app/components/theme_inhereted/theme_locale_model.dart';
import 'package:bracket_card_app/components/theme_inhereted/theme_locale_provider.dart';
import 'package:bracket_card_app/generated/l10n.dart';
import 'package:bracket_card_app/injectable/injectable.dart';
import 'package:bracket_card_app/theme/theme.dart';
import 'package:bracket_card_app/utils/repositories/authorization_repository.dart';
import 'package:client_database/client_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'navigation/router.dart';
import "package:path_provider/path_provider.dart" as path;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  final currentPath = await path.getApplicationSupportDirectory();
  Hive.init(currentPath.path);
  Hive.registerAdapter(CardBoxAdapter());
  Hive.registerAdapter(LearningCardAdapter());
  Hive.registerAdapter(UserAdapter());
  await GetIt.instance<AuthorizationRepository>().init();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(800, 600),
    minimumSize: Size(500, 400),
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );
  if (Platform.isAndroid || Platform.isIOS) {
  } else {
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? lightTheme = prefs.getBool('isLightTheme');
  String? languageCode = prefs.getString('localeLanguageCode');

  final model = ThemeLocaleModel(
    isLightTheme: lightTheme,
    languageCode: languageCode,
  );
  runApp(
    ThemeLocaleProvider(
      model: model,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final isLightTheme =
        ThemeLocaleProvider.watch(context)?.isLightTheme ?? true;
    Locale locale = ThemeLocaleProvider.watch(context)?.locale ??
        const Locale.fromSubtags(languageCode: 'ru');

    return MaterialApp.router(
      locale: locale,
      localizationsDelegates: const [
        SLocale.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: SLocale.delegate.supportedLocales,
      title: 'Flash-Cards-App',
      theme: createLightTheme(),
      darkTheme: createDarkTheme(),
      themeMode: isLightTheme ? ThemeMode.light : ThemeMode.dark,
      routerConfig: router,
    );
  }
}
