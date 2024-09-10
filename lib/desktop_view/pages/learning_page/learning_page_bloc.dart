import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:bracket_card_app/utils/repositories/card_and_cardbox_repository.dart';
import 'package:client_database/client_database.dart';
import 'package:get_it/get_it.dart';

import '../../../utils/usecases/card_and_cardbox_use_case.dart';

part 'learning_page_event.dart';
part 'learning_page_state.dart';

class LearningPageBloc extends Bloc<LearningPageEvent, LearningPageState> {
  Queue<LearningCard> cards = Queue<LearningCard>();
  int passedCards = 0;
  int length = 0;
  LearningPageBloc() : super(LearningPageState()) {
    on<LearningPageLoad>(_init);
    on<LearningPageChangeCard>(_changeCard);
    on<LearningPageSkipCard>(_skipCard);
    on<LearningPageReset>(_reset);
    on<LearningPageDone>(_done);
    on<LearningPagePause>(
        (LearningPagePause event, Emitter<LearningPageState> emit) =>
            emit(state.copyWith(status: LearningPageStatus.paused)));
    on<LearningPageResume>(
        (LearningPageResume event, Emitter<LearningPageState> emit) =>
            emit(state.copyWith(status: LearningPageStatus.ready)));
  }
  final dataproviderUseCase = GetIt.instance<CardandCardBoxUseCase>();
  Future<void> _init(
      LearningPageLoad event, Emitter<LearningPageState> emit) async {
    try {
      await dataproviderUseCase.initCardsDb(event.cardBox);
    } catch (error) {
      if (error is RequestMessage) {
        emit(state.copyWith(
          status: LearningPageStatus.error,
          errorMessage: error.getMessage(),
        ));
      }
    }
    try {
      final list =
          await dataproviderUseCase.showAllCardsFromBoxInDb(event.cardBox);
      cards = Queue.of(list);
      length = cards.length;
      if (length == 0) {
        emit(
          state.copyWith(
            status: LearningPageStatus.error,
            errorMessage:
                "В этом боксе нет карточек, эта страница вообще не должна была загрузиться(",
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: LearningPageStatus.ready,
            card: cards.first,
            passedCards: passedCards,
            length: length,
          ),
        );
      }
    } catch (error) {
      if (error is RequestMessage) {
        emit(
          state.copyWith(
            status: LearningPageStatus.error,
            errorMessage: error.getMessage(),
          ),
        );
      }
    }
  }

  Future<void> _changeCard(
      LearningPageEvent event, Emitter<LearningPageState> emit) async {
    final passedCard = cards.removeFirst();
    passedCard.isSolved = true;
    await dataproviderUseCase.updateCard(passedCard);
    passedCards++;
    if (cards.isNotEmpty) {
      emit(
        state.copyWith(
          card: cards.first,
          passedCards: passedCards,
        ),
      );
    } else {
      emit(
        state.copyWith(
          passedCards: passedCards,
          status: LearningPageStatus.done,
        ),
      );
    }
  }

  Future<void> _skipCard(
      LearningPageSkipCard event, Emitter<LearningPageState> emit) async {
    cards.addLast(cards.removeFirst());
    emit(state.copyWith(card: cards.first));
  }

  FutureOr<void> _reset(
      LearningPageReset event, Emitter<LearningPageState> emit) async {
    passedCards = 0;
    emit(
      state.copyWith(
        status: LearningPageStatus.loading,
        passedCards: 0,
      ),
    );
  }

  Future<void> _done(
      LearningPageDone event, Emitter<LearningPageState> emit) async {
    emit(
      state.copyWith(
        status: LearningPageStatus.done,
        passedCards: passedCards,
      ),
    );
  }
}
