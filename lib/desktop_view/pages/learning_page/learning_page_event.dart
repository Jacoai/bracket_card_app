part of 'learning_page_bloc.dart';

abstract class LearningPageEvent {}

class LearningPageLoad extends LearningPageEvent {
  final CardBox cardBox;
  LearningPageLoad({required this.cardBox});
}

class LearningPageChangeCard extends LearningPageEvent {}

class LearningPageSkipCard extends LearningPageEvent {}

class LearningPagePause extends LearningPageEvent {}

class LearningPageResume extends LearningPageEvent {}

class LearningPageReset extends LearningPageEvent {}

class LearningPageDone extends LearningPageEvent {}
