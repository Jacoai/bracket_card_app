import 'package:bracket_card_app/theme/theme.dart';
import 'package:flutter/material.dart';

class AdaptiveButton extends StatelessWidget {
  const AdaptiveButton({
    super.key,
    required this.label,
    this.onPressed,
    this.baseColor,
    this.icon,
  });
  final IconData? icon;
  final String label;
  final Color? baseColor;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: baseColor ?? Theme.of(context).primaryColor,
        disabledBackgroundColor: AppColors.textColor.withOpacity(0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
            ),
          ),
          if (icon != null)
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
