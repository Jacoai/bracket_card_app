import 'dart:async';

import 'package:bracket_card_app/utils/repositories/card_and_cardbox_repository.dart';
import 'package:bracket_card_app/utils/usecases/card_and_cardbox_use_case.dart';
import 'package:client_database/client_database.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'cards_page_event.dart';
import 'cards_page_state.dart';

class CardsPageBloc extends Bloc<CardsPageEvent, CardsPageState> {
  CardsPageBloc()
      : super(
          CardsPageState(
            cards: [],
            cardBox: null,
            message: const RequestMessage(),
            onlyUnstudied: ValueNotifier(false),
          ),
        ) {
    on<CheckboxChanged>(_onCheckBoxChanged);
    on<CardsPageOpened>(_onCardsPageOpened);
    on<CardAdded>(_onCardAdded);
    on<CardDeleted>(_onCardDeleted);
    on<CardUpdated>(_onCardUpdated);
    on<ClearMessage>(_onClearMessage);
  }

  final _dataproviderUseCase = GetIt.instance<CardandCardBoxUseCase>();
  final ValueNotifier<bool> dataChanged = ValueNotifier(false);

  late final CardBox _cardbox;

  bool findBoxInBd(CardBox cardBox) {
    return _dataproviderUseCase.findCardBoxInDb(cardBox) != null;
  }

  Future<void> _onCardsPageOpened(
    CardsPageOpened event,
    Emitter<CardsPageState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    if (_dataproviderUseCase.findCardBoxInDb(event.cardBox) != null) {
      try {
        await _dataproviderUseCase.initCardsDb(event.cardBox);
      } catch (error) {
        if (error is RequestMessage) {
          emit(
            state.copyWith(
              message: error,
              isLoading: false,
            ),
          );
        }
      }
      _cardbox = event.cardBox;

      try {
        emit(
          state.copyWith(
            cards: await _dataproviderUseCase.showAllCardsFromBoxInDb(_cardbox),
            isLoading: false,
            cardBox: _cardbox,
          ),
        );
      } catch (error) {
        if (error is RequestMessage) {
          emit(
            state.copyWith(
              message: error,
              isLoading: false,
            ),
          );
        }
      }
    } else {
      _cardbox = event.cardBox;

      try {
        emit(
          state.copyWith(
            cards: await _dataproviderUseCase
                .showAllCardsFromBoxFromServer(_cardbox),
            isLoading: false,
            cardBox: _cardbox,
          ),
        );
      } catch (error) {
        if (error is RequestMessage) {
          emit(
            state.copyWith(
              message: error,
              isLoading: false,
            ),
          );
        }
      }
    }
  }

  Future<void> _onCardAdded(
    CardAdded event,
    Emitter<CardsPageState> emit,
  ) async {
    final message = await _dataproviderUseCase.addCard(
      event.card,
      state.cardBox!,
    ); //добаление карточки в бд и на сервер
    dataChanged.value = true;

    final cardbox =
        state.cardBox!.copyWith(cardIds: _cardbox.cardIds..add(event.card.id!));
    //добаляем id  карточки в cardBox

    await _dataproviderUseCase.updateCardBox(_cardbox); //обновляем кардбокс

    emit(
      state.copyWith(
        cardBox: cardbox,
        message: message,
        cards: message.code == 200
            ? await _dataproviderUseCase.showAllCardsFromBoxInDb(_cardbox)
            : state.cards,
      ),
    );
  }

  Future<void> _onCardDeleted(
    CardDeleted event,
    Emitter<CardsPageState> emit,
  ) async {
    dataChanged.value = true;
    await _dataproviderUseCase
        .deleteCard(event.card); //удаляем карточку из бд и из сервера

    final cardIds = _cardbox.cardIds
      ..remove(event.card.id); //удаляем id из бокса

    final message = await _dataproviderUseCase
        .updateCardBox(_cardbox.copyWith(cardIds: cardIds)); //обновляем бокс

    emit(
      state.copyWith(
        cardBox: _cardbox,
        cards: await _dataproviderUseCase.showAllCardsFromBoxInDb(_cardbox),
        message: message, //получаем карточки
      ),
    );
  }

  Future<void> _onCardUpdated(
    CardUpdated event,
    Emitter<CardsPageState> emit,
  ) async {
    dataChanged.value = true;
    await _dataproviderUseCase.updateCard(event.card);
    final message = await _dataproviderUseCase.updateCardBox(_cardbox);
    emit(
      state.copyWith(
        cardBox: _cardbox,
        message: message,
        cards: message.code == 200
            ? await _dataproviderUseCase.showAllCardsFromBoxInDb(_cardbox)
            : state.cards,
      ),
    );
  }

  FutureOr<void> _onClearMessage(
      ClearMessage event, Emitter<CardsPageState> emit) {
    emit(state.copyWith(
      message: const RequestMessage(),
    ));
  }

  Future<void> _onCheckBoxChanged(
      CheckboxChanged event, Emitter<CardsPageState> emit) async {
    state.onlyUnstudied.value = event.value;
    emit(state.copyWith(isLoading: true));
    try {
      final list = await _dataproviderUseCase.showAllCardsFromBoxInDb(
        _cardbox,
      );

      if (event.value == true) {
        emit(
          state.copyWith(
            isLoading: false,
            cards: list.where((element) => element.isSolved == false).toList(),
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            cards: list,
          ),
        );
      }
    } catch (error) {
      emit(state.copyWith(
          isLoading: false,
          message: (error is RequestMessage)
              ? error
              : RequestMessage(message: error.toString())));
    }
    emit(state.copyWith(message: const RequestMessage()));
  }
}
