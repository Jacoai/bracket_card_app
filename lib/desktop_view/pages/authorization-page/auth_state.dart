import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import 'models/models.dart';

enum AuthView {
  logIn,
  signUp;

  AuthView reverseView() {
    return this == AuthView.logIn ? AuthView.signUp : AuthView.logIn;
  }
}

final class AuthPageState extends Equatable {
  final AuthView view;
  final bool isPasswordVisible;
  final Username username;
  final Password password;
  final bool isValid;
  final FormzSubmissionStatus status;
  final String? errorMessage;

  const AuthPageState({
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
    this.isPasswordVisible = false,
    this.view = AuthView.logIn,
    this.errorMessage,
  });

  AuthPageState copyWith({
    FormzSubmissionStatus? status,
    Username? username,
    Password? password,
    AuthView? view,
    bool? isPasswordVisible,
    bool? isValid,
    String? errorMessage,
  }) {
    return AuthPageState(
      view: view ?? this.view,
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        username,
        password,
        status,
        view,
        isPasswordVisible,
        isValid,
        view,
      ];
}
