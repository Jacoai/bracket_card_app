part of '../theme.dart';

abstract class AppTextStyles {
  static const headerStyle1 = TextStyle(
    fontFamily: 'B612 Mono',
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const headerStyle2 = TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const baseText = TextStyle(
    fontSize: 16,
  );

  static const baseTextSmall = TextStyle(
    fontSize: 12,
  );

  static const baseTextWhite = TextStyle(
    fontSize: 16,
    color: AppColors.white,
  );

  static const baseTextSmallWhite = TextStyle(
    fontSize: 12,
    color: AppColors.white,
  );

  static const accentbaseText = TextStyle(
    fontSize: 16,
    color: AppColors.accentYellow,
    fontWeight: FontWeight.w500,
  );
}
