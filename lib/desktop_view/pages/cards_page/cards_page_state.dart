import 'package:bracket_card_app/utils/repositories/card_and_cardbox_repository.dart';
import 'package:client_database/client_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CardsPageState {
  final List<LearningCard> cards;
  final CardBox? cardBox;
  final RequestMessage message;
  final bool isLoading;
  final ValueNotifier<bool> onlyUnstudied;

  CardsPageState({
    required this.cards,
    required this.cardBox,
    required this.message,
    this.isLoading = false,
    required this.onlyUnstudied,
  });

  CardsPageState copyWith({
    CardBox? cardBox,
    List<LearningCard>? cards,
    RequestMessage? message,
    bool? isLoading,
    ValueNotifier<bool>? onlyUnstudied,
  }) {
    return CardsPageState(
      onlyUnstudied: onlyUnstudied ?? this.onlyUnstudied,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      cardBox: cardBox ?? this.cardBox,
      cards: cards ?? this.cards,
    );
  }
}
