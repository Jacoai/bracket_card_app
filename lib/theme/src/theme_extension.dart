part of '../theme.dart';

class ThemeColors extends ThemeExtension<ThemeColors> {
  final Color filterButtonFillColor;
  final Color filterTextColor;
  final Color backgroundColor;
  final Color componentsColor;
  final Color baseFontColor;
  final Color componentDisabledColor;

  const ThemeColors({
    required this.filterButtonFillColor,
    required this.filterTextColor,
    required this.backgroundColor,
    required this.componentsColor,
    required this.baseFontColor,
    required this.componentDisabledColor,
  });

  @override
  ThemeExtension<ThemeColors> copyWith({
    Color? filterButtonFillColor,
    Color? filterTextColor,
    Color? backgroundColor,
    Color? componentsColor,
    Color? baseFontColor,
    Color? componentDisabledColor,
  }) {
    return ThemeColors(
      filterButtonFillColor:
          filterButtonFillColor ?? this.filterButtonFillColor,
      filterTextColor: filterTextColor ?? this.filterTextColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      componentsColor: componentsColor ?? this.componentsColor,
      baseFontColor: baseFontColor ?? this.baseFontColor,
      componentDisabledColor:
          componentDisabledColor ?? this.componentDisabledColor,
    );
  }

  @override
  ThemeExtension<ThemeColors> lerp(
    ThemeExtension<ThemeColors>? other,
    double t,
  ) {
    if (other is! ThemeColors) {
      return this;
    }

    return ThemeColors(
      filterButtonFillColor:
          Color.lerp(filterButtonFillColor, other.filterButtonFillColor, t)!,
      filterTextColor: Color.lerp(filterTextColor, other.filterTextColor, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      componentsColor: Color.lerp(componentsColor, other.componentsColor, t)!,
      baseFontColor: Color.lerp(baseFontColor, other.baseFontColor, t)!,
      componentDisabledColor:
          Color.lerp(componentDisabledColor, other.componentDisabledColor, t)!,
    );
  }

  static get light => const ThemeColors(
      filterButtonFillColor: AppColors.tagsColorLight,
      filterTextColor: AppColors.textColor,
      backgroundColor: AppColors.white,
      componentsColor: AppColors.componentsLight,
      baseFontColor: AppColors.textColor,
      componentDisabledColor: Colors.black45);

  static get dark => const ThemeColors(
      filterButtonFillColor: AppColors.tagsColorDark,
      filterTextColor: AppColors.white,
      backgroundColor: AppColors.backgroundColorDark,
      componentsColor: AppColors.componentsDark,
      baseFontColor: AppColors.white,
      componentDisabledColor: Colors.black45);
}
