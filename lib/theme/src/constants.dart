part of '../theme.dart';

ButtonStyle baseButtonStyle = const ButtonStyle(
  textStyle: MaterialStatePropertyAll(AppTextStyles.headerStyle2),
  iconColor: MaterialStatePropertyAll(Colors.white),
  iconSize: MaterialStatePropertyAll(20),
  foregroundColor: MaterialStatePropertyAll(Colors.white),
  padding: MaterialStatePropertyAll(
    EdgeInsets.symmetric(
      vertical: 15,
      horizontal: 40,
    ),
  ),
  shape: MaterialStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  ),
);

BoxShadow defaultBoxShadow = const BoxShadow(
  color: AppColors.boxShadow,
  blurRadius: 4,
  offset: Offset(0, 4),
);
