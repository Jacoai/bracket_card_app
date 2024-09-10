import 'dart:async';

import 'package:bracket_card_app/generated/l10n.dart';
import 'package:bracket_card_app/utils/usecases/card_and_cardbox_use_case.dart';
import 'package:client_database/client_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';

import '../../../utils/repositories/authorization_repository.dart';
import '../../../utils/repositories/card_and_cardbox_repository.dart';

part 'favorites_page_event.dart';
part 'favorites_page_state.dart';

class FavoritesPageBloc extends Bloc<FavoritesPageEvent, FavoritesPageState> {
  FavoritesPageBloc()
      : super(
          FavoritesPageState(cardboxes: ValueNotifier([])),
        ) {
    on<FavoritesPageOpened>(_onFavoritesPageOpened);
    on<SearchingCardBox>(_onSearchingCardBox);
    on<DeleteFromFavorites>(_onDeleteFromFavorites);
  }
  final _activeUser =
      GetIt.instance<AuthorizationRepository>().activeUser.value;
  final _dataproviderUseCase = GetIt.instance<CardandCardBoxUseCase>();

  ValueNotifier<List<CardBox>> favorites =
      GetIt.instance<CardandCardBoxRepository>().favoritesBoxes;

  Future<void> _onFavoritesPageOpened(
      FavoritesPageOpened event, Emitter<FavoritesPageState> emit) async {
    emit(
      state.copyWith(
        loading: true,
        message: const RequestMessage(),
      ),
    );

    favorites = GetIt.instance<CardandCardBoxRepository>().favoritesBoxes;

    await _dataproviderUseCase.getAllFavoritesCardBoxes(_activeUser!.name);

    emit(state.copyWith(
      loading: false,
      message: const RequestMessage(),
    ));
  }

  Future<void> _onSearchingCardBox(
      SearchingCardBox event, Emitter<FavoritesPageState> emit) async {
    emit(state.copyWith(
      loading: true,
      message: null,
    ));
    final searchingList = favorites.value
        .where(
          (element) => element.boxName.contains(event.searchValue),
        )
        .toList();
    if (searchingList.isEmpty) {
      emit(
        state.copyWith(
          loading: false,
          message: RequestMessage(
            code: 200,
            message: SLocale.current.notExist,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          cardboxes: ValueNotifier(searchingList),
          loading: false,
          message: const RequestMessage(),
        ),
      );
    }
  }

  Future<void> _onDeleteFromFavorites(
      DeleteFromFavorites event, Emitter<FavoritesPageState> emit) async {
    final message =
        await _dataproviderUseCase.deleteFromFavorite(event.cardBox);

    emit(
      state.copyWith(
        message: message,
        cardboxes: favorites,
      ),
    );
    emit(state.copyWith(
      message: const RequestMessage(),
    ));
  }
}
