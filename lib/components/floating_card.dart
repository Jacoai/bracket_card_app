import 'package:bracket_card_app/theme/theme.dart';
import 'package:flutter/material.dart';

class FloatingCard extends Container {
  FloatingCard({
    required this.width,
    required this.height,
    super.key,
    required this.text,
  });
  final String text;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(
          AppTextStyles.baseText.fontSize!,
        ),
      ),
      padding: EdgeInsets.all(
        AppTextStyles.baseText.fontSize!,
      ),
      child: Center(
        child: Text(text),
      ),
    );
  }
}
