import 'package:client_database/client_database.dart';

class CardBoxEditorState {
  CardBoxEditorState({
    required this.isValid,
    this.inProcces = false,
    required this.cardbox,
  });
  final bool isValid;
  final bool inProcces;
  final CardBox cardbox;

  CardBoxEditorState copyWith({
    bool? isValid,
    bool? inProcces,
    CardBox? cardbox,
  }) {
    return CardBoxEditorState(
      isValid: isValid ?? this.isValid,
      inProcces: inProcces ?? this.inProcces,
      cardbox: cardbox ?? this.cardbox,
    );
  }
}
