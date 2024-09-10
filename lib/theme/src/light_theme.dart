part of '../theme.dart';

ThemeData createLightTheme() {
  return ThemeData(
    //  textTheme: createTextTheme(),
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color.fromARGB(255, 211, 211, 211),
    primaryColor: AppColors.lightBlue,
    fontFamily: 'JetBrains Mono',
    primaryColorDark: const Color.fromARGB(255, 38, 46, 90),
    primaryColorLight: const Color.fromARGB(255, 155, 167, 236),
    cardColor: AppColors.white,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightBlue,
    ),

    secondaryHeaderColor: AppColors.accentYellow,
    extensions: <ThemeExtension<dynamic>>[
      ThemeColors.light,
    ],
    dialogTheme: const DialogTheme(
      backgroundColor: AppColors.componentsLight,
      titleTextStyle: AppTextStyles.headerStyle1,
      contentTextStyle: AppTextStyles.baseText,
    ),
    focusColor: AppColors.lightBlue.withOpacity(0.2),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBlue,
      titleTextStyle: AppTextStyles.headerStyle1,
      centerTitle: true,
    ),
    textButtonTheme: TextButtonThemeData(
      style: baseButtonStyle.copyWith(
        backgroundColor: const MaterialStatePropertyAll(AppColors.lightBlue),
        overlayColor:
            const MaterialStatePropertyAll(Color.fromARGB(255, 90, 100, 161)),
      ),
    ),
    drawerTheme: const DrawerThemeData(),
  );
}
