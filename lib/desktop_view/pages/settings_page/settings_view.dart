import 'package:bracket_card_app/components/adaptive_button.dart';
import 'package:bracket_card_app/components/error_messager/error_messager.dart';
import 'package:bracket_card_app/components/password_field/password_field.dart';
import 'package:bracket_card_app/components/theme_inhereted/theme_locale_provider.dart';
import 'package:bracket_card_app/desktop_view/modal_windows/show_animated_dialog.dart';

import 'package:bracket_card_app/desktop_view/pages/settings_page/settings_bloc.dart';
import 'package:bracket_card_app/desktop_view/pages/settings_page/settings_event.dart';
import 'package:bracket_card_app/desktop_view/pages/settings_page/settings_state.dart';
import 'package:bracket_card_app/generated/l10n.dart';
import 'package:bracket_card_app/theme/theme.dart';
import 'package:bracket_card_app/utils/consts/consts.dart';
import 'package:bracket_card_app/utils/models/user_avatar.dart';
import 'package:bracket_card_app/utils/repositories/card_and_cardbox_repository.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

enum LocaleLabel {
  russian(
    'Русский',
    Locale.fromSubtags(languageCode: 'ru'),
  ),
  english(
    'English',
    Locale.fromSubtags(languageCode: 'en'),
  );

  final String label;
  final Locale locale;
  const LocaleLabel(this.label, this.locale);

  factory LocaleLabel.fromLocale(Locale locale) {
    if (locale == LocaleLabel.russian.locale) {
      return russian;
    } else {
      return english;
    }
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController localeController = TextEditingController();
  final TextEditingController passwordCurrentControler =
      TextEditingController();
  final TextEditingController passwordNewControler = TextEditingController();
  final TextEditingController passwordNewRepeatControler =
      TextEditingController();

  final bloc = SettingsPageBLoc()..add(SettingsPageOpened());

  @override
  Widget build(BuildContext context) {
    bool isLightTheme = ThemeLocaleProvider.read(context)?.isLightTheme ?? true;
    Locale? curLoc = ThemeLocaleProvider.read(context)?.locale ??
        const Locale.fromSubtags(languageCode: 'ru');
    LocaleLabel currentLocaleLabel = LocaleLabel.fromLocale(curLoc);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 50, 10, 10),
              child: themeWidget(isLightTheme),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 50, 10, 10),
              child: localeWidget(currentLocaleLabel),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 50, 10, 10),
              child: passwordWidget(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 50, 10, 10),
              child: avatarWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget themeWidget(bool isLightTheme) {
    final MaterialStateProperty<Icon?> thumbIcon =
        MaterialStateProperty.resolveWith<Icon?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return const Icon(Icons.light_mode_outlined);
        }
        return const Icon(Icons.dark_mode_outlined);
      },
    );
    return OverflowBar(
      alignment: MainAxisAlignment.spaceEvenly,
      overflowAlignment: OverflowBarAlignment.center,
      overflowSpacing: 15,
      children: [
        Container(
          alignment: Alignment.center,
          width: 300,
          child: Text(
            SLocale.of(context).changeTheme,
            style: AppTextStyles.headerStyle1,
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: 400,
          child: Switch(
            value: isLightTheme,
            onChanged: (bool value) => setState(
              () {
                isLightTheme = value;
                ThemeLocaleProvider.read(context)?.changeTheme(isLightTheme);
              },
            ),
            thumbIcon: thumbIcon,
          ),
        ),
      ],
    );
  }

  Widget localeWidget(LocaleLabel currentLocaleLabel) {
    return OverflowBar(
      alignment: MainAxisAlignment.spaceEvenly,
      overflowAlignment: OverflowBarAlignment.center,
      overflowSpacing: 15,
      children: [
        Container(
          alignment: Alignment.center,
          width: 300,
          child: Text(
            SLocale.of(context).language,
            style: AppTextStyles.headerStyle1,
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: 400,
          child: DropdownMenu<LocaleLabel>(
            initialSelection: currentLocaleLabel,
            controller: localeController,
            onSelected: (LocaleLabel? value) async {
              setState(
                () {
                  currentLocaleLabel = value ?? currentLocaleLabel;
                  ThemeLocaleProvider.read(context)
                      ?.setLocale(currentLocaleLabel.locale);
                },
              );
            },
            dropdownMenuEntries:
                LocaleLabel.values.map<DropdownMenuEntry<LocaleLabel>>(
              (LocaleLabel locale) {
                return DropdownMenuEntry<LocaleLabel>(
                  value: locale,
                  label: locale.label,
                );
              },
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget passwordWidget() {
    return OverflowBar(
      alignment: MainAxisAlignment.spaceEvenly,
      overflowAlignment: OverflowBarAlignment.center,
      overflowSpacing: 15,
      children: [
        Container(
          alignment: Alignment.center,
          width: 300,
          child: Text(
            SLocale.of(context).changePassword,
            style: AppTextStyles.headerStyle1,
          ),
        ),
        BlocProvider(
          create: (context) => bloc,
          child: BlocListener<SettingsPageBLoc, SettingsPageState>(
            listener: (context, state) {
              if (state.needToShowResult) {
                showAnimatedDialog(
                  context,
                  ErrorMesseger(
                    errorName: SLocale.of(context).password,
                    errorDescribe: state.authStatus,
                  ),
                );
                bloc.add(
                  ResultWasShown(),
                );
              }
            },
            child: BlocBuilder<SettingsPageBLoc, SettingsPageState>(
              builder: (context, state) {
                return !state.isPasswordChanging
                    ? Column(
                        children: [
                          PasswordField(
                            textEditingController: passwordCurrentControler,
                            textInputAction: TextInputAction.next,
                            labelText: SLocale.of(context).password,
                          ),
                          PasswordField(
                            textEditingController: passwordNewControler,
                            textInputAction: TextInputAction.next,
                            labelText: SLocale.of(context).newPassword,
                            onChanged: (String value) {
                              bloc.add(
                                ValidateNewPasswordEvent(
                                  newPassword: value,
                                ),
                              );
                            },
                          ),
                          PasswordField(
                            textEditingController: passwordNewRepeatControler,
                            textInputAction: TextInputAction.done,
                            labelText: SLocale.of(context).newPasswordRepeat,
                            onChanged: (String value) {
                              bloc.add(
                                ValidateNewPasswordRepeatEvent(
                                  newPasswordRepeat: value,
                                ),
                              );
                            },
                          ),
                          AdaptiveButton(
                            label: SLocale.of(context).toChangePassword,
                            onPressed: state.isNewPasswordsValid
                                ? () {
                                    if (passwordNewControler.text !=
                                        passwordNewRepeatControler.text) {
                                      showAnimatedDialog(
                                        context,
                                        ErrorMesseger(
                                          errorName:
                                              SLocale.of(context).password,
                                          errorDescribe: SLocale.of(context)
                                              .newPasswordsDontMatch,
                                        ),
                                      );
                                    } else {
                                      bloc.add(
                                        ChangePasswordEvent(
                                          password:
                                              passwordCurrentControler.text,
                                          newPassword:
                                              passwordNewControler.text,
                                        ),
                                      );
                                      passwordCurrentControler.clear();
                                      passwordNewControler.clear();
                                      passwordNewRepeatControler.clear();
                                    }
                                  }
                                : null,
                          ),
                        ],
                      )
                    : Container(
                        width: 200,
                        height: 200,
                        padding: const EdgeInsets.all(50),
                        child: const CircularProgressIndicator(),
                      );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget avatarWidget() {
    return OverflowBar(
      alignment: MainAxisAlignment.spaceEvenly,
      overflowAlignment: OverflowBarAlignment.center,
      overflowSpacing: 15,
      children: [
        ValueListenableBuilder<UserAvatar?>(
          valueListenable: GetIt.I<CardandCardBoxRepository>().userAvatar,
          builder: (context, value, child) => Container(
              padding: const EdgeInsets.all(8.0),
              width: 200,
              height: 200,
              child: value == null
                  ? Image.asset('assets/images/user_man.png')
                  : ClipOval(
                      child: Image.network(value.path),
                    )),
        ),
        Column(
          children: [
            AdaptiveButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                  allowedExtensions: [
                    'aif',
                    'aifs',
                    'bmp',
                    'jpg',
                    'jpeg',
                    'png',
                  ],
                );
                if (result == null) {
                  return;
                }
                if (result.files.first.size > MB * 5) {
                  if (!context.mounted) return;
                  showAnimatedDialog(
                    context,
                    ErrorMesseger(
                      errorName: SLocale.of(context).avatar,
                      errorDescribe: SLocale.of(context).imageSize5Mb,
                    ),
                  );
                  return;
                }
                final avatarPath = result.files.first.path;
                if (avatarPath != null) {
                  bloc.add(
                    ChangeAvatarEvent(path: avatarPath),
                  );
                }
              },
              label: SLocale.of(context).changeAvatar,
            ),
            Text(
              SLocale.of(context).imageSizeNoMore5Mb,
              style: AppTextStyles.baseTextSmall,
            )
          ],
        ),
      ],
    );
  }
}
