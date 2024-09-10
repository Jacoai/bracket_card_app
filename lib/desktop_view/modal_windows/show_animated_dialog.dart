import 'package:flutter/material.dart';

void showAnimatedDialog(
  BuildContext context,
  Widget child,
) {
  showGeneralDialog(
    context: context,
    transitionDuration: const Duration(milliseconds: 300),
    barrierLabel: "Barrier",
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionBuilder: (context, a1, a2, widget) {
      return FadeTransition(
        opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
        child: Material(
          color: Colors.transparent,
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) => Container(),
  );
}
