import 'package:bracket_card_app/components/theme_inhereted/theme_locale_model.dart';
import 'package:flutter/material.dart';

class ThemeLocaleProvider extends InheritedNotifier<ThemeLocaleModel> {
  final ThemeLocaleModel model;

  const ThemeLocaleProvider({
    super.key,
    required this.model,
    required super.child,
  }) : super(
          notifier: model,
        );

  static ThemeLocaleModel? watch(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ThemeLocaleProvider>()
        ?.model;
  }

  static ThemeLocaleModel? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<ThemeLocaleProvider>()
        ?.widget;
    return widget is ThemeLocaleProvider ? widget.notifier : null;
  }
}
