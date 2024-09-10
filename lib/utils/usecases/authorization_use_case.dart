import 'package:bracket_card_app/generated/l10n.dart';
import 'package:client_database/client_database.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../repositories/authorization_repository.dart';

@injectable
class AuthorizationUseCase {
  AuthorizationUseCase(
    @injectable this._serverRepository,
  );
  late final AuthorizationRepository _serverRepository;

  Future<void> init() async {
    await _serverRepository.init();
  }

  Future<AuthStatus> logIn(String username, String password) async {
    try {
      final status = await _serverRepository.logIn(
        User(
          name: username,
          password: password,
        ),
      );
      if (kDebugMode) {
        print(status.name);
      }
      return status;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return AuthStatus.globalError;
    }
  }

  Future<AuthStatus> signUp(String username, String password) async {
    final user = User(
      name: username,
      password: password,
    );
    try {
      final status = await _serverRepository.signUp(user);
      if (kDebugMode) {
        print(status.name);
      }
      if (status == AuthStatus.success) {
        return await _serverRepository.logIn(user);
      } else {
        return status;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return AuthStatus.globalError;
    }
  }

  Future<bool> logOut() async {
    return await _serverRepository.logOut();
  }

  Future<String> changePassword(String password, String newPassword) async {
    try {
      final status =
          await _serverRepository.changePassword(password, newPassword);
      if (kDebugMode) {
        print(status);
      }
      return status;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return SLocale.current.globalError;
    }
  }
}
