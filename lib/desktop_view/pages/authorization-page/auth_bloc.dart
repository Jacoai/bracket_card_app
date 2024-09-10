import 'package:bracket_card_app/generated/l10n.dart';
import 'package:bracket_card_app/utils/repositories/authorization_repository.dart';
import 'package:bracket_card_app/utils/usecases/authorization_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import '../../../utils/repositories/card_and_cardbox_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'models/models.dart';

class AuthPageBloc extends Bloc<AuthPageEvent, AuthPageState> {
  AuthPageBloc()
      : super(
          const AuthPageState(
            view: AuthView.logIn,
          ),
        ) {
    on<TryAuthorization>(_tryingAuthorization);

    on<AuthPageOpened>(_authPageOpened);

    on<ChangePageView>(_changePageView);

    on<UsernameUnfocused>(_usernameUnfocused);
    on<PasswordUnfocused>(_passwordUnfocused);

    on<ChangePasswordVisibility>(_changePasswordVisibility);

    on<UsernameChanged>(_usernameChanged);

    on<PasswordChanged>(_passwordChanged);
  }

  String authStatusMessage(AuthStatus status) {
    switch (status) {
      case AuthStatus.globalError:
        return SLocale.current.globalError;
      case AuthStatus.success:
        return SLocale.current.success;
      case AuthStatus.invailidData:
        return SLocale.current.invailidData;
      case AuthStatus.invalidLoginorPassword:
        return SLocale.current.invalidLoginorPassword;
      case AuthStatus.userExist:
        return SLocale.current.userExist;
    }
  }

  final AuthorizationUseCase _authorizationUseCase =
      GetIt.instance.get<AuthorizationUseCase>();

  Future<void> _usernameUnfocused(
      UsernameUnfocused event, Emitter<AuthPageState> emit) async {
    final username = Username.dirty(state.username.value);
    emit(
      state.copyWith(
        username: username,
        isValid: Formz.validate([username, state.password]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  Future<void> _passwordUnfocused(
    PasswordUnfocused event,
    Emitter<AuthPageState> emit,
  ) async {
    final password = Password.dirty(state.password.value);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.username, password]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  Future<void> _changePasswordVisibility(
    ChangePasswordVisibility event,
    Emitter<AuthPageState> emit,
  ) async {
    emit(
      state.copyWith(
          isPasswordVisible: !state.isPasswordVisible,
          status: FormzSubmissionStatus.initial),
    );
  }

  Future<void> _usernameChanged(
      UsernameChanged event, Emitter<AuthPageState> emit) async {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username.isValid ? username : Username.pure(event.username),
        isValid: Formz.validate([
          username,
          state.password,
        ]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  Future<void> _passwordChanged(
      PasswordChanged event, Emitter<AuthPageState> emit) async {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password.isValid ? password : Password.pure(event.password),
        isValid: Formz.validate([
          state.username,
          password,
        ]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  Future<void> _changePageView(
      ChangePageView event, Emitter<AuthPageState> emit) async {
    emit(
      state.copyWith(
        view: state.view.reverseView(),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  Future<void> _authPageOpened(
      AuthPageOpened event, Emitter<AuthPageState> emit) async {
    emit(
      state.copyWith(
        view: AuthView.logIn,
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  Future<void> _tryingAuthorization(
    TryAuthorization event,
    Emitter<AuthPageState> emit,
  ) async {
    final username = Username.dirty(state.username.value);
    final password = Password.dirty(state.password.value);
    emit(
      state.copyWith(
        username: username,
        password: password,
        isValid: Formz.validate([username, password]),
        status: FormzSubmissionStatus.initial,
      ),
    );

    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

      if (state.view == AuthView.signUp) {
        final status = await _authorizationUseCase.signUp(
          state.username.value,
          state.password.value,
        );
        if (status != AuthStatus.success) {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.failure,
              errorMessage: authStatusMessage(status),
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.success,
            ),
          );
          await GetIt.instance<CardandCardBoxRepository>().init();
        }
      } else if (state.view == AuthView.logIn) {
        final status = await _authorizationUseCase.logIn(
          state.username.value,
          state.password.value,
        );
        if (status != AuthStatus.success) {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.failure,
              errorMessage: authStatusMessage(status),
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: FormzSubmissionStatus.success,
            ),
          );
          await GetIt.instance<CardandCardBoxRepository>().init();
          await GetIt.instance<CardandCardBoxRepository>()
              .getAvatar(state.username.value);
        }
      }
    }
  }
}
