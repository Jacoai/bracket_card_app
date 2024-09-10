import 'package:bracket_card_app/theme/theme.dart';
import 'package:flutter/material.dart';

class TagLabel extends StatelessWidget {
  const TagLabel({
    super.key,
    required this.text,
    required this.color,
    this.onEdditing = false,
    this.onTap,
    this.onSearching,
  });

  final Color color;
  final String text;
  final bool onEdditing;
  final void Function(String)? onSearching;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    double fontSize = AppTextStyles.baseTextSmall.fontSize!;
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: fontSize * 0.5,
        horizontal: fontSize,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          MediaQuery.of(context).size.height * 0.5,
        ),
      ),
      child: InkWell(
        onTap: onEdditing
            ? null
            : () {
                onSearching!(text);
              },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.fade,
            ),
            if (onEdditing)
              InkWell(
                onTap: onTap,
                child: const Icon(
                  Icons.close,
                  color: AppColors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
