part of 'favorites_page_bloc.dart';

abstract class FavoritesPageEvent {}

class FavoritesPageOpened extends FavoritesPageEvent {}

class SearchingCardBox extends FavoritesPageEvent {
  final String searchValue;
  SearchingCardBox({required this.searchValue});
}

class DeleteFromFavorites extends FavoritesPageEvent {
  final CardBox cardBox;
  DeleteFromFavorites({required this.cardBox});
}
