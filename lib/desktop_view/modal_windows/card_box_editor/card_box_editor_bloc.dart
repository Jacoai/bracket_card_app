import 'package:bracket_card_app/desktop_view/modal_windows/card_box_editor/card_box_editor_event.dart';
import 'package:bracket_card_app/desktop_view/modal_windows/card_box_editor/card_box_editor_state.dart';
import 'package:bracket_card_app/generated/l10n.dart';
import 'package:bracket_card_app/utils/repositories/authorization_repository.dart';
import 'package:bracket_card_app/utils/usecases/card_and_cardbox_use_case.dart';
import 'package:client_database/client_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class CardBoxEditorBloc extends Bloc<CardBoxEditorEvent, CardBoxEditorState> {
  CardBoxEditorBloc()
      : super(CardBoxEditorState(
          isValid: false,
          cardbox: CardBox(
            cardIds: [],
            author: '',
            boxName: '',
            category: [],
          ),
        )) {
    on<EditorOpened>(_onEditorOpened);
    on<CreatorOpened>(_onCreatorOpened);
    on<AddNewCategory>(_onAddNewCategory);
    on<ChangedBoxName>(_onChangeBoxName);
    on<DeletedCategory>(_onDeletedCategory);
    on<TryAdding>(_onTryAdding);
    on<ChangePrivate>(_onChangePrivate);
  }

  ValueNotifier<bool> dataChanged = ValueNotifier(false);

  static final RegExp _regexForBoxName = RegExp(
      r'''^[А-ЯЁа-яёa-zA-Z0-9][ А-ЯЁа-яёa-zA-Z0-9_.!'"#$%&(),+-:;/<\=>?@`{|}~^*\/\[\]\\]*$''');
  static final _regexForCategory =
      RegExp(r'^[a-zA-Zа-яА-ЯЁё0-9][a-zA-Zа-яА-ЯЁё0-9 ]*$');

  String? isBoxNameValid(String value) {
    if (value.length > 50) {
      return SLocale.current.boxNameIsTooLong;
    } else if (value.isEmpty) {
      return null;
    } else if (!_regexForBoxName.hasMatch(value)) {
      return SLocale.current.invalidSimbolsForBoxandCategory;
    } else {
      return null;
    }
  }

  String? isCategoryValid(String value) {
    if (value.length > 15) {
      return SLocale.current.categoryIsTooLong;
    } else if (value.isEmpty) {
      return null;
    } else if (!_regexForCategory.hasMatch(value)) {
      return SLocale.current.invalidSimbolsForBoxandCategory;
    } else {
      return null;
    }
  }

  final activeUser = GetIt.instance<AuthorizationRepository>().activeUser.value;
  final dataproviderUseCase = GetIt.instance<CardandCardBoxUseCase>();

  Future<void> _onTryAdding(
    TryAdding event,
    Emitter<CardBoxEditorState> emit,
  ) async {
    emit(
      state.copyWith(
        inProcces: true,
      ),
    );
  }

  Future<void> _onEditorOpened(
    EditorOpened event,
    Emitter<CardBoxEditorState> emit,
  ) async {
    emit(
      state.copyWith(
        cardbox: event.cardBox,
        isValid: true,
        inProcces: false,
      ),
    );
    dataChanged.value = false;
  }

  Future<void> _onCreatorOpened(
    CreatorOpened event,
    Emitter<CardBoxEditorState> emit,
  ) async {
    emit(
      state.copyWith(
        cardbox: state.cardbox.copyWith(
          author: activeUser!.name,
        ),
        isValid: false,
        inProcces: false,
      ),
    );
    dataChanged.value = false;
  }

  Future<void> _onAddNewCategory(
    AddNewCategory event,
    Emitter<CardBoxEditorState> emit,
  ) async {
    emit(
      state.copyWith(
          cardbox: state.cardbox.copyWith(
              category: state.cardbox.category..add(event.newCategory)),
          isValid: state.cardbox.category.isNotEmpty &&
              state.cardbox.category.length < 6 &&
              state.cardbox.boxName.isNotEmpty &&
              isBoxNameValid(state.cardbox.boxName) == null),
    );
    dataChanged.value = true;
  }

  Future<void> _onDeletedCategory(
    DeletedCategory event,
    Emitter<CardBoxEditorState> emit,
  ) async {
    emit(
      state.copyWith(
          cardbox: state.cardbox.copyWith(
              category: state.cardbox.category..removeAt(event.index)),
          isValid: state.cardbox.category.isNotEmpty &&
              state.cardbox.category.length < 6 &&
              state.cardbox.boxName.isNotEmpty &&
              isBoxNameValid(state.cardbox.boxName) == null),
    );
    dataChanged.value = true;
  }

  Future<void> _onChangeBoxName(
    ChangedBoxName event,
    Emitter<CardBoxEditorState> emit,
  ) async {
    emit(
      state.copyWith(
          cardbox: state.cardbox.copyWith(boxName: event.name),
          isValid: state.cardbox.category.isNotEmpty &&
              state.cardbox.category.length < 6 &&
              event.name.isNotEmpty &&
              isBoxNameValid(event.name) == null),
    );
    dataChanged.value = true;
  }

  Future<void> _onChangePrivate(
    ChangePrivate event,
    Emitter<CardBoxEditorState> emit,
  ) async {
    emit(state.copyWith(
      cardbox: state.cardbox.copyWith(private: event.value),
    ));
  }
}
