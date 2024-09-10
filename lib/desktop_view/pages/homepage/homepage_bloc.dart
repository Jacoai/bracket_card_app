import 'dart:async';

import 'package:bracket_card_app/utils/repositories/authorization_repository.dart';
import 'package:bracket_card_app/utils/repositories/card_and_cardbox_repository.dart';
import 'package:bracket_card_app/utils/usecases/card_and_cardbox_use_case.dart';

import 'package:client_database/client_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'homepage_event.dart';
import 'homepage_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc()
      : super(HomePageState(
          user: ValueNotifier<User?>(null),
          cardBoxes: ValueNotifier([]),
          message: const RequestMessage(),
        )) {
    on<HomePageOpened>(_onHomePageOpened);
    on<AddCardBox>(_onAddCardBox);
    on<UpdateCardBox>(_onUpdateCardBox);
    on<SearchingCardBox>(_onSearchingCardBox);
    on<SearchingCardBoxByTag>(_onSearchingCardBoxByTag);
    on<ChangeAddToFavorite>(_onAddToFavorite);
    on<ClearMessage>(_onClearMessage);
    on<DeleteCardBox>(_onDeleteCardBox);
  }

  final activeUser = GetIt.instance<AuthorizationRepository>().activeUser.value;
  final dataproviderUseCase = GetIt.instance<CardandCardBoxUseCase>();

  final ValueNotifier<List<CardBox>> cardboxes = ValueNotifier([]);

  Future<void> _onSearchingCardBox(
    SearchingCardBox event,
    Emitter<HomePageState> emit,
  ) async {
    if (event.searchValue.isNotEmpty) {
      emit(state.copyWith(cardBoxLoading: true));
      try {
        final findCardBoxes = await dataproviderUseCase.findBoxes(
          '',
          event.searchValue,
        );
        emit(
          state.copyWith(
            cardBoxes: ValueNotifier(findCardBoxes),
            cardBoxLoading: false,
            searchingByTag: false,
          ),
        );
      } catch (error) {
        if (error is RequestMessage) {
          emit(
            state.copyWith(
              message: error,
              cardBoxLoading: false,
              searchingByTag: false,
              cardBoxes: state.cardBoxes,
            ),
          );
        }
      }
    } else {
      emit(state.copyWith(
          cardBoxLoading: false,
          cardBoxes: ValueNotifier(
              await dataproviderUseCase.getAllCardBoxes(activeUser!.name))));
    }
  }

  Future<void> _onHomePageOpened(
    HomePageOpened event,
    Emitter<HomePageState> emit,
  ) async {
    emit(state.copyWith(cardBoxLoading: true));
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      final box = await dataproviderUseCase.getAllCardBoxes(activeUser!.name);

      emit(
        state.copyWith(
          cardBoxes: ValueNotifier(box),
          searchingByTag: false,
          cardBoxLoading: false,
        ),
      );
    } catch (error) {
      if (error is RequestMessage) {
        emit(state.copyWith(
          message: error,
          cardBoxLoading: false,
        ));
      }
    }
  }

  Future<void> _onAddCardBox(
    AddCardBox event,
    Emitter<HomePageState> emit,
  ) async {
    final message = await dataproviderUseCase.addCardBox(event.cardBox);
    if (message.code != 200) {
      emit(state.copyWith(message: message));
    } else {
      emit(
        state.copyWith(
            cardBoxes: ValueNotifier(
          state.cardBoxes.value
            ..add(event.cardBox)
            ..toList(),
        )),
      );
    }
  }

  Future<void> _onUpdateCardBox(
    UpdateCardBox event,
    Emitter<HomePageState> emit,
  ) async {
    final list = state.cardBoxes.value;
    final index = list
        .indexOf(list.firstWhere((element) => element.id == event.cardBox.id));
    list.removeAt(index);
    list.insert(index, event.cardBox);
    emit(
      state.copyWith(
        cardBoxes: ValueNotifier(list),
      ),
    );
  }

  Future<void> _onSearchingCardBoxByTag(
      SearchingCardBoxByTag event, Emitter<HomePageState> emit) async {
    emit(state.copyWith(cardBoxLoading: true));
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      final list = await dataproviderUseCase.findBoxes(
        event.searchValue,
        '',
      );
      emit(
        state.copyWith(
          cardBoxes: ValueNotifier(list),
          searchingByTag: true,
          searchingTag: event.searchValue,
          cardBoxLoading: false,
        ),
      );
    } catch (error) {
      if (error is RequestMessage) {
        emit(
          state.copyWith(
            message: error,
            cardBoxLoading: false,
          ),
        );
      }
    }
  }

  Future<void> _onAddToFavorite(
      ChangeAddToFavorite event, Emitter<HomePageState> emit) async {
    final message = event.isAdded
        ? await dataproviderUseCase.deleteFromFavorite(event.cardBox)
        : await dataproviderUseCase.addBoxToFavorite(event.cardBox);
    emit(state.copyWith(message: message));
  }

  Future<void> _onClearMessage(
      ClearMessage event, Emitter<HomePageState> emit) async {
    emit(state.copyWith(message: const RequestMessage()));
  }

  Future<void> _onDeleteCardBox(
      DeleteCardBox event, Emitter<HomePageState> emit) async {
    final list = state.cardBoxes.value;
    final index = list.indexOf(
      list.firstWhere((element) => element.id == event.cardBox.id),
    );
    list.removeAt(index);
    emit(
      state.copyWith(
        cardBoxes: ValueNotifier(list),
      ),
    );
  }
}
