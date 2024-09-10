// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import '../utils/repositories/authorization_repository.dart' as _i3;
import '../utils/repositories/card_and_cardbox_repository.dart' as _i5;
import '../utils/usecases/authorization_use_case.dart' as _i4;
import '../utils/usecases/card_and_cardbox_use_case.dart' as _i6;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.AuthorizationRepository>(
        () => _i3.AuthorizationRepository());
    gh.factory<_i4.AuthorizationUseCase>(
        () => _i4.AuthorizationUseCase(gh<_i3.AuthorizationRepository>()));
    gh.singleton<_i5.CardandCardBoxRepository>(
        () => _i5.CardandCardBoxRepository());
    gh.factory<_i6.CardandCardBoxUseCase>(
        () => _i6.CardandCardBoxUseCase(gh<_i5.CardandCardBoxRepository>()));
    return this;
  }
}
