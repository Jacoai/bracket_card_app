import 'package:client_database/client_database.dart';

class CardEditorState {
  CardEditorState({
    required this.isValid,
    required this.card,
    this.inProcces = false,
  });

  final LearningCard card;
  final bool isValid;
  final bool inProcces;

  CardEditorState copyWith({
    LearningCard? card,
    bool? isValid,
    bool? inProcces,
  }) {
    return CardEditorState(
      card: card ?? this.card,
      isValid: isValid ?? this.isValid,
      inProcces: inProcces ?? this.inProcces,
    );
  }
}
