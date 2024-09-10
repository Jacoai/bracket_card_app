import 'package:bracket_card_app/generated/l10n.dart';
import 'package:client_database/controllers/token_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:client_database/client_database.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:client_database/src/models/token_pair_model/token_pair_model.dart';
import 'package:encrypt/encrypt.dart' as encr;

@singleton
class AuthorizationRepository {
  late AuthRemoteDataProvider? _server;
  late Dio dio;
  late TokenController tokenController;
  late encr.Encrypter encrypter;

  final ValueNotifier<User?> activeUser = ValueNotifier(null);

  final key = encr.Key.fromBase64('9c5de008640cd6dcb808afeac3f1d315');
  late Box box;

  bool isUserAuthorized() {
    return activeUser.value != null;
  }

  Future<void> clearRefreshToken() async {
    box = await Hive.openBox('config');
    await box.clear();
    await box.close();
  }

  Future<void> storeRefreshToken(
    String refreshToken,
    String username,
  ) async {
    box = await Hive.openBox('config');
    final encrypted = encrypter
        .encrypt(
          refreshToken,
          iv: encr.IV.fromUtf8('0'),
        )
        .bytes;
    await box.put('refresh_token', encrypted);
    final name = encrypter
        .encrypt(
          username,
          iv: encr.IV.fromUtf8('0'),
        )
        .bytes;
    await box.put('username', name);
    await box.close();
  }

  Future<List<int>?> getDataFromHive(String name) async {
    box = await Hive.openBox('config');
    final encrypted = await box.get(name);
    if (encrypted != null) {
      return encrypter.decryptBytes(
        encr.Encrypted(encrypted),
        iv: encr.IV.fromUtf8('0'),
      );
    }
    await box.close();
    return null;
  }

  Future<void> init() async {
    try {
      encrypter = encr.Encrypter(
        encr.AES(
          key,
          mode: encr.AESMode.ctr,
          padding: null,
        ),
      );
      tokenController =
          TokenController(); //создаёт контроллер токенов, который работает для AuthProvider.
      dio = Dio();
      dio.options.connectTimeout =
          const Duration(seconds: 3); //таймаут на отправление
      dio.options.receiveTimeout =
          const Duration(seconds: 2); //таймаут на получение
      dio.options.baseUrl = "http://88.201.200.203:8082/api/";
      dio.interceptors
          .add(PrettyDioLogger()); //дефолтый адрес(писать один раз!!!)
      dio.interceptors.add(InterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await tokenController.refreshToken(dio); //обработка refresh
            final opts = Options(
                //копирование параметров предыдущего запроса для его повторения
                method: error.requestOptions.method,
                headers: error.requestOptions.headers);
            final cloneReq = await dio.request(error.requestOptions.path,
                options: opts,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters);

            return handler.resolve(cloneReq); //повторение запроса
          }

          return handler.next(error);
        },
      ));
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }

    await fastLogIn();
  }

  Future<String?> fastLogIn() async {
    final storedToken = await getDataFromHive('refresh_token');
    final username = await getDataFromHive('username');
    if (storedToken != null && username != null) {
      tokenController.tokens = TokenPair(String.fromCharCodes(storedToken), "");
      try {
        await tokenController.refreshToken(dio); //получаем оба токена

        activeUser.value =
            User(name: String.fromCharCodes(username), password: "");
        _server = AuthRemoteDataProvider(
          activeUser.value!,
          dio,
          tokenController,
        );
        return activeUser.value!.name;
      } catch (error) {
        if (error is AuthException) {
          return null;
        }
      }
    }
    return null;
  }

  Future<AuthStatus> signUp(User user) async {
    _server = AuthRemoteDataProvider(
      user,
      dio,
      tokenController,
    );
    try {
      await _server!.signUp();
    } catch (error) {
      if (error is AuthException) {
        if (error.statusCode == 400) {
          return AuthStatus.invailidData;
        } else if (error.statusCode == 403) {
          return AuthStatus.userExist;
        }
      } else {
        if (kDebugMode) {
          print(error);
        }
        return AuthStatus.globalError;
      }
    }
    return AuthStatus.success;
  }

  Future<AuthStatus> logIn(User user) async {
    _server = AuthRemoteDataProvider(
      user,
      dio,
      tokenController,
    );
    try {
      await _server!.logIn();
      activeUser.value = User(
        name: user.name,
        password: user.password,
      );
    } catch (error) {
      _server = null;
      if (error is AuthException) {
        if (error.statusCode == 400) {
          return AuthStatus.invailidData;
        } else if (error.statusCode == 403) {
          return AuthStatus.invalidLoginorPassword;
        }
      } else {
        if (kDebugMode) {
          print(error);
        }
        return AuthStatus.globalError;
      }
    }

    await storeRefreshToken(
      tokenController.tokens!.refreshToken,
      activeUser.value!.name,
    );

    return AuthStatus.success;
  }

  Future<bool> logOut() async {
    try {
      _server = AuthRemoteDataProvider(
        activeUser.value!,
        dio,
        tokenController,
      );
      activeUser.value = null;
      await _server!.logOut();
      await clearRefreshToken();
      return true;
    } catch (error) {
      if (error is AuthException) {}
      if (kDebugMode) {
        print('Что-то пошло не так при поытке выхода');
      }
      return false;
    }
  }

  Future<String> changePassword(String password, String newPassword) async {
    try {
      await _server!.changePassword(newPassword, password);
    } catch (error) {
      if (error is AuthException) {
        if (error.statusCode == 400) {
          return SLocale.current.wrongInputData;
        } else if (error.statusCode == 403) {
          return SLocale.current.incorrectPassword;
        }
      } else {
        if (kDebugMode) {
          print(error);
        }
        return SLocale.current.globalError;
      }
    }
    return SLocale.current.passwordChangedSuccessfully;
  }
}

enum AuthStatus {
  success('Авторизация прошла успешно!'),
  userExist('Пользователь с таким никнеймом уже существует'),
  invailidData('Некорректные данные'),
  invalidLoginorPassword(
      'Пользователь с таким никнеймом не существует или неверный пароль'),
  globalError('Что-то пошло не так'),
  ;

  const AuthStatus(this.message);
  final String message;
}
