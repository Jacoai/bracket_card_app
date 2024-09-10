import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:client_database/client_database.dart';
import 'package:get_it/get_it.dart';

import '../../../utils/usecases/card_and_cardbox_use_case.dart';

part 'card_box_info_event.dart';
part 'card_box_info_state.dart';

class CardBoxInfoBloc extends Bloc<CardBoxInfoEvent, CardBoxInfoState> {
  CardBoxInfoBloc() : super(CardBoxInfoState()) {
    on<CardBoxInfoLoad>(_init);
    on<CardBoxInfoDelete>(_delete);
    on<CardBoxInfoUpdate>(_update);
    on<CardBoxInfoChangedAddedToFavorites>(_changedAddedToFavorites);
  }
  final _dataproviderUseCase = GetIt.instance<CardandCardBoxUseCase>();
  Future<void> _init(
    CardBoxInfoLoad event,
    Emitter<CardBoxInfoState> emit,
  ) async {
    try {
      emit(state.copyWith(
          cardBox: event.cardBox, status: CardBoxInfoLoadStatus.ready));
    } catch (e) {
      emit(state.copyWith(
          status: CardBoxInfoLoadStatus.error, errorMsg: e.toString()));
    }
  }

  Future<void> _delete(
    CardBoxInfoDelete event,
    Emitter<CardBoxInfoState> emit,
  ) async {
    await _dataproviderUseCase.deleteCardBox(event.cardBox);
    emit(state.copyWith(status: CardBoxInfoLoadStatus.loading));
  }

  Future<void> _update(
    CardBoxInfoUpdate event,
    Emitter<CardBoxInfoState> emit,
  ) async {
    await _dataproviderUseCase.updateCardBox(event.cardBox);
    emit(state.copyWith(cardBox: event.cardBox, changed: true));
  }

  Future<void> _changedAddedToFavorites(
      CardBoxInfoChangedAddedToFavorites event,
      Emitter<CardBoxInfoState> emit) async {
    final message = event.isAdded
        ? await _dataproviderUseCase.deleteFromFavorite(event.cardBox)
        : await _dataproviderUseCase.addBoxToFavorite(event.cardBox);
    emit(
        state.copyWith(errorMsg: message.code != 200 ? message.message : null));
  }
}
