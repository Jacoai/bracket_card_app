import 'package:bracket_card_app/utils/repositories/card_and_cardbox_repository.dart';
import 'package:client_database/client_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomePageState {
  ValueNotifier<User?> user;
  ValueNotifier<List<CardBox>> cardBoxes;
  bool searchingByTag;
  String? searchingTag;
  bool cardBoxLoading;
  RequestMessage message;

  HomePageState(
      {required this.user,
      required this.cardBoxes,
      this.searchingByTag = false,
      this.searchingTag,
      this.cardBoxLoading = false,
      required this.message});

  HomePageState copyWith({
    ValueNotifier<User>? user,
    ValueNotifier<List<CardBox>>? cardBoxes,
    bool? searchingByTag,
    String? searchingTag,
    bool? cardBoxLoading,
    RequestMessage? message,
  }) {
    return HomePageState(
      message: message ?? this.message,
      searchingTag: searchingTag ?? this.searchingTag,
      user: user ?? this.user,
      searchingByTag: searchingByTag ?? this.searchingByTag,
      cardBoxes: cardBoxes ?? this.cardBoxes,
      cardBoxLoading: cardBoxLoading ?? this.cardBoxLoading,
    );
  }
}
