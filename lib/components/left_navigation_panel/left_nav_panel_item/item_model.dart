import 'package:flutter/material.dart';

class LeftNavigationPanelItemModel {
  const LeftNavigationPanelItemModel({
    this.label,
    this.icon,
    this.onTap,
  });
  final String? label;
  final IconData? icon;
  final void Function()? onTap;
}
