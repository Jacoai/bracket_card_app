abstract class AuthPageEvent {}

final class AuthPageOpened extends AuthPageEvent {}

final class UsernameChanged extends AuthPageEvent {
  final String username;
  UsernameChanged({required this.username});
}

final class PasswordChanged extends AuthPageEvent {
  final String password;
  PasswordChanged({required this.password});
}

final class UsernameUnfocused extends AuthPageEvent {}

final class PasswordUnfocused extends AuthPageEvent {}

final class ChangePasswordVisibility extends AuthPageEvent {}

final class ChangePageView extends AuthPageEvent {}

final class TryAuthorization extends AuthPageEvent {}
