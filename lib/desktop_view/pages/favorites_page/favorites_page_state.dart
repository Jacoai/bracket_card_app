part of 'favorites_page_bloc.dart';

class FavoritesPageState {
  final ValueNotifier<List<CardBox>> cardboxes;
  final bool loading;
  final RequestMessage message;

  const FavoritesPageState({
    required this.cardboxes,
    this.loading = false,
    this.message = const RequestMessage(),
  });

  FavoritesPageState copyWith({
    ValueNotifier<List<CardBox>>? cardboxes,
    bool? loading,
    RequestMessage? message,
  }) {
    return FavoritesPageState(
        cardboxes: cardboxes ?? this.cardboxes,
        loading: loading ?? this.loading,
        message: message ?? this.message);
  }
}
