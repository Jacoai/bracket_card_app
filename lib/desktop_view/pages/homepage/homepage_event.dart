import 'package:client_database/client_database.dart';

abstract class HomePageEvent {}

class HomePageOpened extends HomePageEvent {}

class AddCardBox extends HomePageEvent {
  final CardBox cardBox;
  AddCardBox({required this.cardBox});
}

class ClearMessage extends HomePageEvent {
  ClearMessage();
}

class ChangeAddToFavorite extends HomePageEvent {
  final bool isAdded;
  final CardBox cardBox;
  ChangeAddToFavorite({
    required this.cardBox,
    required this.isAdded,
  });
}

class UpdateCardBox extends HomePageEvent {
  final CardBox cardBox;
  UpdateCardBox({required this.cardBox});
}

class DeleteCardBox extends HomePageEvent {
  final CardBox cardBox;
  DeleteCardBox({required this.cardBox});
}

class SearchingCardBox extends HomePageEvent {
  final String searchValue;
  SearchingCardBox({required this.searchValue});
}

class SearchingCardBoxByTag extends HomePageEvent {
  final String searchValue;
  SearchingCardBoxByTag({required this.searchValue});
}
