abstract class SettingsPageEvent {}

class SettingsPageOpened extends SettingsPageEvent {}

class ChangePasswordEvent extends SettingsPageEvent {
  ChangePasswordEvent({
    required this.password,
    required this.newPassword,
  });

  final String newPassword;
  final String password;
}

class ValidateNewPasswordEvent extends SettingsPageEvent {
  ValidateNewPasswordEvent({
    required this.newPassword,
  });
  String newPassword;
}

class ValidateNewPasswordRepeatEvent extends SettingsPageEvent {
  ValidateNewPasswordRepeatEvent({
    required this.newPasswordRepeat,
  });
  String newPasswordRepeat;
}

class ResultWasShown extends SettingsPageEvent {}

class ChangeAvatarEvent extends SettingsPageEvent {
  String path;

  ChangeAvatarEvent({
    required this.path,
  });
}

