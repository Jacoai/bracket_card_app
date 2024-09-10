part of 'card_box_info_bloc.dart';

abstract class CardBoxInfoEvent {}

class CardBoxInfoLoad extends CardBoxInfoEvent {
  final CardBox? cardBox;
  CardBoxInfoLoad({required this.cardBox});
}

class CardBoxInfoDelete extends CardBoxInfoEvent {
  final CardBox cardBox;
  CardBoxInfoDelete({required this.cardBox});
}

class CardBoxInfoChangedAddedToFavorites extends CardBoxInfoEvent {
  final bool isAdded;
  final CardBox cardBox;
  CardBoxInfoChangedAddedToFavorites({
    required this.isAdded,
    required this.cardBox,
  });
}

class CardBoxInfoUpdate extends CardBoxInfoEvent {
  final CardBox cardBox;
  CardBoxInfoUpdate({required this.cardBox});
}
