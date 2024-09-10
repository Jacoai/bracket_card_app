import 'package:bracket_card_app/components/adaptive_button.dart';
import 'package:bracket_card_app/generated/l10n.dart';
import 'package:bracket_card_app/theme/theme.dart';
import 'package:flutter/material.dart';

import '../modal_window_title/modal_window_title.dart';

class ErrorMesseger extends StatefulWidget {
  final String errorName;
  final String? errorDescribe;
  final bool isWarningMessage;

  const ErrorMesseger({
    super.key,
    this.errorDescribe,
    required this.errorName,
    this.isWarningMessage = false,
  });

  @override
  State<ErrorMesseger> createState() => _ErrorMessegerState();
}

class _ErrorMessegerState extends State<ErrorMesseger> {
  late ThemeColors colors;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    colors = Theme.of(context).extension<ThemeColors>()!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: ModalWindowTitle(
        title: widget.errorName.toString(),
        icon: Icon(
          widget.isWarningMessage ? Icons.warning : Icons.error,
          color: AppColors.white,
        ),
      ),
      titlePadding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).primaryColor,
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          color: colors.backgroundColor,
        ),
        width: MediaQuery.of(context).size.width / 4,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: Text(
                    widget.errorDescribe ?? widget.errorName,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.baseText.copyWith(
                      color: colors.baseFontColor,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AdaptiveButton(
                    onPressed: () => Navigator.pop(context, true),
                    label: SLocale.of(context).ok,
                  ),
                  if (widget.isWarningMessage)
                    AdaptiveButton(
                      onPressed: () => Navigator.pop(context, false),
                      label: SLocale.of(context).cancel,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.zero,
      alignment: Alignment.center,
    );
  }
}
