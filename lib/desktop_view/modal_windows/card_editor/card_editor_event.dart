import 'package:client_database/client_database.dart';

abstract class CardEditorEvent {}

final class EditorOpened extends CardEditorEvent {
  final LearningCard card;
  EditorOpened({required this.card});
}

final class CreatorOpened extends CardEditorEvent {}

final class TryAdding extends CardEditorEvent {}

final class ChangedFrontNote extends CardEditorEvent {
  final String frontNote;
  ChangedFrontNote({required this.frontNote});
}

final class ChangedBackNote extends CardEditorEvent {
  final String backNote;
  ChangedBackNote({required this.backNote});
}

final class ChangedUniversal extends CardEditorEvent {
  final bool value;
  ChangedUniversal({required this.value});
}

final class ChangedisSolved extends CardEditorEvent {
  final bool value;
  ChangedisSolved({required this.value});
}

final class ChangedCardMode extends CardEditorEvent {
  final bool value;
  ChangedCardMode({required this.value});
}
