part of '../theme.dart';

ThemeData createDarkTheme() {
  return ThemeData(
    //  textTheme: createTextTheme(),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundColorDark,
    primaryColor: AppColors.darkBlue,
    primaryColorDark: const Color.fromARGB(255, 18, 22, 43),
    primaryColorLight: const Color.fromARGB(255, 55, 60, 88),
    fontFamily: 'JetBrains Mono',
    secondaryHeaderColor: AppColors.accentYellow,
    extensions: <ThemeExtension<dynamic>>[
      ThemeColors.dark,
    ],
    dialogTheme: const DialogTheme(
 
      titleTextStyle: AppTextStyles.headerStyle1,
      contentTextStyle: AppTextStyles.baseText,
    ),
    focusColor: AppColors.darkBlue.withOpacity(0.2),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBlue,
      titleTextStyle: AppTextStyles.headerStyle1,
      centerTitle: true,
    ),
    textButtonTheme: TextButtonThemeData(
      style: baseButtonStyle.copyWith(
        backgroundColor: const MaterialStatePropertyAll(AppColors.darkBlue),
      ),
    ),
    drawerTheme: const DrawerThemeData(),
    navigationDrawerTheme: const NavigationDrawerThemeData(
      backgroundColor: AppColors.componentsDark,
    ),
  );
}
