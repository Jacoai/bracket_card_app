import 'package:bracket_card_app/components/modal_window_title/modal_window_title.dart';
import 'package:bracket_card_app/generated/l10n.dart';
import 'package:bracket_card_app/theme/theme.dart';

import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: ModalWindowTitle(
        //TODO: дизайн
        title: SLocale.of(context).userInformation,
        icon: const Icon(
          Icons.info,
          color: AppColors.white,
        ),
      ),
      titlePadding: const EdgeInsets.all(10),
      backgroundColor: theme.primaryColor,
      contentPadding: EdgeInsets.zero,
      content: Container(
        color: theme.scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'как только бэк сделают тут будут диаграммки по статистике\nИзучено карточек\nПеревернуто карточек:\nСоздано боксов:\nИзучено боксов :\n',
                style: AppTextStyles.baseText.copyWith(
                    color: theme.extension<ThemeColors>()!.baseFontColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
