part of 'learning_page_bloc.dart';

enum LearningPageStatus {
  loading,
  ready,
  paused,
  error,
  done,
}

enum LearningPageMode {
  basic,
  timed,
  control,
}

class LearningPageState {
  LearningPageState({
    this.passedCards = 0,
    this.length = 0,
    this.card,
    this.status = LearningPageStatus.loading,
    this.errorMessage,
    this.mode = LearningPageMode.basic,
    this.currentTimeLeft = 0,
  });
  final LearningCard? card;
  final int passedCards;
  final int length;
  final LearningPageStatus status;
  final LearningPageMode mode;
  final String? errorMessage;
  final int? currentTimeLeft;

  LearningPageState copyWith({
    LearningCard? card,
    int? passedCards,
    int? length,
    LearningPageStatus? status,
    String? errorMessage,
    final int? currentTimeLeft,
  }) {
    return LearningPageState(
      card: card ?? this.card,
      passedCards: passedCards ?? this.passedCards,
      length: length ?? this.length,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentTimeLeft: currentTimeLeft ?? this.currentTimeLeft,
    );
  }
}
