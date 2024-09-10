import 'package:client_database/client_database.dart';

abstract class CardsPageEvent {}

final class CardsPageOpened extends CardsPageEvent {
  final CardBox cardBox;
  CardsPageOpened({required this.cardBox});
}

final class CheckboxChanged extends CardsPageEvent {
  final bool value;
  CheckboxChanged({required this.value});
}

final class CardSearching extends CardsPageEvent {}

final class CardDeleted extends CardsPageEvent {
  final LearningCard card;
  CardDeleted({required this.card});
}

class ClearMessage extends CardsPageEvent {
  ClearMessage();
}

final class CardAdded extends CardsPageEvent {
  final LearningCard card;
  CardAdded({required this.card});
}

final class CardUpdated extends CardsPageEvent {
  final LearningCard card;
  CardUpdated({
    required this.card,
  });
}
