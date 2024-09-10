import 'package:flutter/material.dart';

import '../theme/theme.dart';

class LabelWithToolTip extends StatefulWidget {
  const LabelWithToolTip({
    super.key,
    required this.label,
    required this.tooltip,
    this.width = 150,
  });
  final String label;
  final double width;
  final String? tooltip;

  @override
  State<LabelWithToolTip> createState() => _LabelWithToolTipState();
}

class _LabelWithToolTipState extends State<LabelWithToolTip> {
  bool tooltipVisibility = false;
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
            widget.tooltip != null
                ? InkWell(
                    onTap: () {
                      setState(
                        () {
                          tooltipVisibility = !tooltipVisibility;
                        },
                      );
                    },
                    child: const Icon(
                      Icons.question_mark,
                      color: AppColors.white,
                    ),
                  )
                : const SizedBox(),
            Expanded(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 200),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.label,
                      style: AppTextStyles.baseText.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ),
                    tooltipVisibility
                        ? Text(
                            widget.tooltip ?? '',
                            style: AppTextStyles.baseTextSmallWhite,
                          )
                        : const SizedBox()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
