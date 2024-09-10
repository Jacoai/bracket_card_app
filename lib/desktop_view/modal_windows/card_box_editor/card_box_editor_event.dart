import 'package:client_database/client_database.dart';

abstract class CardBoxEditorEvent {}

final class EditorOpened extends CardBoxEditorEvent {
  final CardBox cardBox;
  EditorOpened({required this.cardBox});
}

final class CreatorOpened extends CardBoxEditorEvent {}

final class TryAdding extends CardBoxEditorEvent {}

final class AddNewCategory extends CardBoxEditorEvent {
  final String newCategory;
  AddNewCategory({required this.newCategory});
}

final class DeletedCategory extends CardBoxEditorEvent {
  final int index;
  DeletedCategory({required this.index});
}

final class ChangedBoxName extends CardBoxEditorEvent {
  final String name;
  ChangedBoxName({required this.name});
}

final class ChangedColor extends CardBoxEditorEvent {
  final double value;
  ChangedColor({required this.value});
}

final class ChangePrivate extends CardBoxEditorEvent {
  final bool value;
  ChangePrivate({required this.value});
}
