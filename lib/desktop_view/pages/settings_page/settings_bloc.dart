import 'package:bracket_card_app/desktop_view/pages/authorization-page/models/models.dart';
import 'package:bracket_card_app/utils/repositories/authorization_repository.dart';
import 'package:bracket_card_app/utils/usecases/authorization_use_case.dart';
import 'package:bracket_card_app/utils/usecases/card_and_cardbox_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:get_it/get_it.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsPageBLoc extends Bloc<SettingsPageEvent, SettingsPageState> {
  SettingsPageBLoc() : super(SettingsPageState()) {
    on<ChangePasswordEvent>(changePasswordEvent);
    on<SettingsPageOpened>(settingsPageOpened);
    on<ResultWasShown>(resultWasShow);
    on<ValidateNewPasswordEvent>(validateNewPasswordEvent);
    on<ValidateNewPasswordRepeatEvent>(validateNewPasswordRepeatEvent);
    on<ChangeAvatarEvent>(changeAvatarEvent);
  }

  final activeUser = GetIt.instance<AuthorizationRepository>().activeUser.value;

  final AuthorizationUseCase _authorizationUseCase =
      GetIt.instance.get<AuthorizationUseCase>();
  final CardandCardBoxUseCase _cardandCardBoxUseCase =
      GetIt.instance.get<CardandCardBoxUseCase>();

  Future<void> settingsPageOpened(
      SettingsPageOpened event, Emitter<SettingsPageState> emit) async {
    if (activeUser != null) {
      final password = Password.dirty(activeUser!.password);
      emit(
        state.copyWith(
          password: password,
        ),
      );
    }
  }

  Future<void> changePasswordEvent(
      ChangePasswordEvent event, Emitter<SettingsPageState> emit) async {
    emit(
      state.copyWith(
        isPasswordChanging: true,
      ),
    );
    final password = Password.dirty(event.newPassword);
    String authStatus = await _authorizationUseCase.changePassword(
      event.password,
      password.value,
    );
    await Future.delayed(const Duration(milliseconds: 500));
    emit(
      state.copyWith(
        password: password,
        isPasswordChanging: false,
        authStatus: authStatus,
        needToShowResult: true,
        isNewPasswordsValid: false,
      ),
    );
  }

  Future<void> resultWasShow(
      ResultWasShown event, Emitter<SettingsPageState> emit) async {
    emit(
      state.copyWith(
        needToShowResult: false,
      ),
    );
  }

  Future<void> validateNewPasswordEvent(
    ValidateNewPasswordEvent event,
    Emitter<SettingsPageState> emit,
  ) async {
    final newPassword = Password.dirty(event.newPassword);
    emit(
      state.copyWith(
        newPassword: newPassword.isNotValid
            ? newPassword
            : Password.pure(event.newPassword),
        isNewPasswordsValid: Formz.validate(
          [
            newPassword,
            state.newPasswordRepeat,
          ],
        ),
      ),
    );
  }

  Future<void> validateNewPasswordRepeatEvent(
    ValidateNewPasswordRepeatEvent event,
    Emitter<SettingsPageState> emit,
  ) async {
    final newPasswordRepeat = Password.dirty(event.newPasswordRepeat);
    emit(
      state.copyWith(
        newPasswordRepeat: newPasswordRepeat.isNotValid
            ? newPasswordRepeat
            : Password.pure(event.newPasswordRepeat),
        isNewPasswordsValid: Formz.validate(
          [
            newPasswordRepeat,
            state.newPassword,
          ],
        ),
      ),
    );
  }

  Future<void> changeAvatarEvent(
    ChangeAvatarEvent event,
    Emitter<SettingsPageState> emit,
  ) async {
    await _cardandCardBoxUseCase.setAvatar(
      event.path,
      activeUser!.name,
    );
    await _cardandCardBoxUseCase.getAvatar(
      activeUser!.name,
    );
  }
}
