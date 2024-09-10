import 'dart:async';
import 'package:bracket_card_app/generated/l10n.dart';
import 'package:client_database/client_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'card_editor_event.dart';
import 'card_editor_state.dart';

class CardEditorBloc extends Bloc<CardEditorEvent, CardEditorState> {
  CardEditorBloc()
      : super(CardEditorState(
          card: LearningCard(
            frontNote: '',
            backNote: '',
            showTime: DateTime.now(),
          ),
          isValid: false,
        )) {
    on<EditorOpened>(_onEditorOpened);
    on<CreatorOpened>(_onCreatorOpened);
    on<ChangedBackNote>(_onChangedBackNote);
    on<ChangedFrontNote>(_onChangedFronNote);
    on<ChangedUniversal>(_onChangeUniversal);
    on<ChangedisSolved>(_onChangedIsSolved);
    on<ChangedCardMode>(_onChangedCardMode);
    on<TryAdding>(_onTryAdding);
  }

  ValueNotifier<bool> dataChanged = ValueNotifier(false);

  static final RegExp _regexForNote = RegExp(
      r'''^[А-Яа-яa-zA-ZЁё0-9][ А-Яа-яa-zA-ZЁё0-9_.!'"#$%&(),+-:;/<\=>?@`{|}~^*\/\[\]\\]*$''');

  String? isNoteValid(String value) {
    if (value.length > 250) {
      return SLocale.current.noteIsTooLong;
    } else if (value.isEmpty) {
      return null;
    } else if (!_regexForNote.hasMatch(value)) {
      return SLocale.current.invailidData;
    } else {
      return null;
    }
  }

  Future<void> _onTryAdding(
    TryAdding event,
    Emitter<CardEditorState> emit,
  ) async {
    emit(
      state.copyWith(
        inProcces: true,
      ),
    );
  }

  Future<void> _onEditorOpened(
    EditorOpened event,
    Emitter<CardEditorState> emit,
  ) async {
    emit(
      state.copyWith(
        card: event.card,
        isValid: true,
        inProcces: false,
      ),
    );
    dataChanged.value = false;
  }

  Future<void> _onCreatorOpened(
    CreatorOpened event,
    Emitter<CardEditorState> emit,
  ) async {
    emit(
      state.copyWith(
        isValid: false,
        inProcces: false,
      ),
    );
    dataChanged.value = false;
  }

  Future<void> _onChangedBackNote(
    ChangedBackNote event,
    Emitter<CardEditorState> emit,
  ) async {
    emit(
      state.copyWith(
        card: state.card.copyWith(backNote: event.backNote),
        isValid: isNoteValid(event.backNote) == null &&
            isNoteValid(state.card.frontNote) == null &&
            state.card.frontNote.isNotEmpty &&
            event.backNote.isNotEmpty,
      ),
    );
    dataChanged.value = true;
  }

  Future<void> _onChangeUniversal(
    ChangedUniversal event,
    Emitter<CardEditorState> emit,
  ) async {
    emit(
      state.copyWith(
        card: state.card.copyWith(universal: event.value),
      ),
    );
    dataChanged.value = true;
  }

  Future<void> _onChangedFronNote(
    ChangedFrontNote event,
    Emitter<CardEditorState> emit,
  ) async {
    emit(
      state.copyWith(
        card: state.card.copyWith(frontNote: event.frontNote),
        isValid: isNoteValid(event.frontNote) == null &&
            isNoteValid(state.card.backNote) == null &&
            event.frontNote.isNotEmpty &&
            state.card.backNote.isNotEmpty,
      ),
    );
    dataChanged.value = true;
  }

  FutureOr<void> _onChangedIsSolved(
      ChangedisSolved event, Emitter<CardEditorState> emit) {
    emit(
      state.copyWith(
        card: state.card.copyWith(isSolved: event.value),
      ),
    );
    dataChanged.value = true;
  }

  Future<void> _onChangedCardMode(
      ChangedCardMode event, Emitter<CardEditorState> emit) async {
    emit(
      state.copyWith(
        card: state.card.copyWith(
          mode: event.value == true ? 'answerInput' : 'standart',
        ),
      ),
    );
    dataChanged.value = true;
  }
}
