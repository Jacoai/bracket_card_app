import 'package:bracket_card_app/components/tag_label.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class LabelWithIcon extends StatelessWidget {
  const LabelWithIcon({
    super.key,
    required this.label,
    this.width = 150,
    required this.onTap,
    required this.tag,
  });
  final String label;
  final String tag;
  final double width;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.headerStyle2,
            ),
           
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TagLabel(
                text: tag,
                color: Theme.of(context)
                    .extension<ThemeColors>()!
                    .filterButtonFillColor,
              ),
            ),
            IconButton(
              onPressed: () {
                onTap();
              },
              icon: const Icon(
                Icons.close,
                color: AppColors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
