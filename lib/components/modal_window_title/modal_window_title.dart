import 'package:bracket_card_app/components/error_messager/error_messager.dart';
import 'package:bracket_card_app/generated/l10n.dart';
import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class ModalWindowTitle extends StatelessWidget {
  const ModalWindowTitle({
    super.key,
    this.icon,
    required this.title,
    this.checkDataPersistence = false,
    this.desktopView = true,
  });
  final bool checkDataPersistence;
  final Icon? icon;
  final String title;
  final bool desktopView;

  void showWarningMessage(BuildContext context) {
    checkDataPersistence
        ? showDialog<bool>(
            context: context,
            builder: (context) => ErrorMesseger(
              isWarningMessage: true,
              errorName: SLocale.of(context).exitWithoutSaving,
              errorDescribe: SLocale.of(context).exitWithoutSavingMessage,
            ),
          ).then(
            (value) {
              if (value != null && value) {
                Navigator.pop(context);
              }
            },
          )
        : Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Theme.of(context).primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            if (!desktopView)
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: AppColors.white,
                ),
                onPressed: () => showWarningMessage(context),
              ),
            Padding(
                padding: const EdgeInsets.all(5.0),
                child: icon ?? const SizedBox()),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.headerStyle2.copyWith(height: 0.85),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.clip,
              ),
            ),
            if (desktopView)
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: AppColors.white,
                ),
                onPressed: () => showWarningMessage(context),
              )
          ],
        ),
      ),
    );
  }
}
