import 'package:bracket_card_app/desktop_view/pages/authorization-page/models/models.dart';

final class SettingsPageState {
  final Password password;
  final Password newPassword;
  final Password newPasswordRepeat;
  final bool isNewPasswordsValid;

  final bool isPasswordChanging;
  final String? authStatus;
  final bool needToShowResult;

  SettingsPageState({
    this.password = const Password.pure(),
    this.isPasswordChanging = false,
    this.authStatus,
    this.needToShowResult = false,
    this.newPassword = const Password.pure(),
    this.newPasswordRepeat = const Password.pure(),
    this.isNewPasswordsValid = false,
  });

  SettingsPageState copyWith({
    Password? password,
    Password? newPassword,
    Password? newPasswordRepeat,
    bool? isPasswordChanging,
    String? authStatus,
    bool? needToShowResult,
    bool? isNewPasswordsValid,
  }) {
    return SettingsPageState(
      password: password ?? this.password,
      isPasswordChanging: isPasswordChanging ?? this.isPasswordChanging,
      authStatus: authStatus ?? this.authStatus,
      needToShowResult: needToShowResult ?? this.needToShowResult,
      newPassword: newPassword ?? this.newPassword,
      newPasswordRepeat: newPasswordRepeat ?? this.newPasswordRepeat,
      isNewPasswordsValid: isNewPasswordsValid ?? this.isNewPasswordsValid,
    );
  }
}
