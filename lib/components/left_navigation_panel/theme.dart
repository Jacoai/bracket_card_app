import 'package:flutter/material.dart';

class LeftNavigationPanelTheme {
  const LeftNavigationPanelTheme({
    this.width = 70,
    this.height = double.infinity,
    this.margin = EdgeInsets.zero,
    this.decoration,
    this.iconTheme,
    this.selectedIconTheme,
    this.textStyle,
    this.selectedTextStyle,
    this.itemDecoration,
    this.selectedItemDecoration,
    this.hoverColor,
    this.hoverTextStyle,
  });

  final double width;

  final double height;

  final EdgeInsets margin;

  final BoxDecoration? decoration;

  final IconThemeData? iconTheme;

  final IconThemeData? selectedIconTheme;

  final TextStyle? textStyle;

  final TextStyle? selectedTextStyle;

  final BoxDecoration? itemDecoration;

  final BoxDecoration? selectedItemDecoration;

  final Color? hoverColor;

  final TextStyle? hoverTextStyle;

  LeftNavigationPanelTheme copyWith({
    double? width,
    double? height,
    EdgeInsets? padding,
    EdgeInsets? margin,
    BoxDecoration? decoration,
    IconThemeData? iconTheme,
    IconThemeData? selectedIconTheme,
    TextStyle? textStyle,
    TextStyle? selectedTextStyle,
    BoxDecoration? itemDecoration,
    BoxDecoration? selectedItemDecoration,
    Color? hoverColor,
    TextStyle? hoverTextStyle,
  }) {
    return LeftNavigationPanelTheme(
      width: width ?? this.width,
      height: height ?? this.height,
      margin: margin ?? this.margin,
      decoration: decoration ?? this.decoration,
      iconTheme: iconTheme ?? this.iconTheme,
      selectedIconTheme: selectedIconTheme ?? this.selectedIconTheme,
      textStyle: textStyle ?? this.textStyle,
      selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
      itemDecoration: itemDecoration ?? this.itemDecoration,
      selectedItemDecoration:
          selectedItemDecoration ?? this.selectedItemDecoration,
      hoverColor: hoverColor ?? this.hoverColor,
      hoverTextStyle: hoverTextStyle ?? this.hoverTextStyle,
    );
  }
}
