import 'dart:io';

import 'package:bracket_card_app/components/adaptive_button.dart';
import 'package:bracket_card_app/components/label_with_tooltip.dart';
import 'package:bracket_card_app/components/modal_window_title/modal_window_title.dart';
import 'package:bracket_card_app/components/switch.dart';
import 'package:bracket_card_app/components/text_field.dart';

import 'package:bracket_card_app/theme/theme.dart';
import 'package:client_database/client_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../generated/l10n.dart';
import 'card_editor_bloc.dart';
import 'card_editor_event.dart';
import 'card_editor_state.dart';

class CardEditor extends StatefulWidget {
  const CardEditor({
    super.key,
    required this.onTap,
    this.card,
  });
  final LearningCard? card;
  final void Function(LearningCard?) onTap;

  @override
  State<CardEditor> createState() => _CardEditorState();
}

class _CardEditorState extends State<CardEditor> {
  late CardEditorBloc bloc;
  @override
  void initState() {
    bloc = CardEditorBloc()
      ..add(
        widget.card == null
            ? CreatorOpened()
            : EditorOpened(
                card: widget.card!,
              ),
      );

    super.initState();
  }

  Widget _title(bool isDesktopView) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ValueListenableBuilder(
          valueListenable: bloc.dataChanged,
          builder: (context, value, child) => ModalWindowTitle(
            desktopView: isDesktopView,
            checkDataPersistence: value,
            title: widget.card == null
                ? SLocale.of(context).cardCreating
                : SLocale.of(context).cardEditting,
            icon: widget.card == null
                ? const Icon(
                    Icons.create,
                    color: AppColors.white,
                  )
                : const Icon(
                    Icons.edit,
                    color: AppColors.white,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      width: (Platform.isAndroid || Platform.isIOS)
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width * 0.5,
      height: (Platform.isAndroid || Platform.isIOS)
          ? MediaQuery.of(context).size.height * 0.8
          : MediaQuery.of(context).size.height / 1.5,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LabelWithToolTip(
                width: 250,
                label: SLocale.of(context).frontNote,
                tooltip: SLocale.of(context).frontNoteTooltip,
              ),
            ),
            Center(
              child: CustomTextField(
                isCardField: true,
                initialValue: widget.card?.frontNote ?? '',
                maxLines: 3,
                onTapSuffixIcon: (value) =>
                    bloc.add(ChangedFrontNote(frontNote: '')),
                validator: (value) => bloc.isNoteValid(value ?? ''),
                onChanged: (value) => bloc.add(
                  ChangedFrontNote(frontNote: value),
                ),
                padding: const EdgeInsets.all(20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LabelWithToolTip(
                width: 250,
                label: SLocale.of(context).backNote,
                tooltip: SLocale.of(context).backNoteTooltip,
              ),
            ),
            CustomTextField(
              isCardField: true,
              initialValue: widget.card?.backNote ?? '',
              maxLines: 3,
              onTapSuffixIcon: (value) =>
                  bloc.add(ChangedBackNote(backNote: '')),
              validator: (value) => bloc.isNoteValid(value ?? ''),
              onChanged: (value) => bloc.add(
                ChangedBackNote(backNote: value),
              ),
              padding: const EdgeInsets.all(20),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomSwitch(
                tooltip: SLocale.of(context).universalTooltip,
                iconSelected: Icons.check,
                iconBase: Icons.close_outlined,
                label: SLocale.of(context).isUniversal,
                value: widget.card?.universal ?? false,
                onChanged: (value) {
                  bloc.add(
                    ChangedUniversal(value: value),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomSwitch(
                tooltip: SLocale.of(context).solvedTooltip,
                iconSelected: Icons.check,
                iconBase: Icons.close_outlined,
                label: SLocale.of(context).isSolved,
                value: widget.card?.isSolved ?? false,
                onChanged: (value) {
                  bloc.add(
                    ChangedisSolved(value: value),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomSwitch(
                tooltip: SLocale.of(context).cardModeTooltip,
                iconSelected: Icons.edit_calendar_sharp,
                iconBase: Icons.close_outlined,
                label: SLocale.of(context).isWriteble,
                value: widget.card?.mode == 'answerInput' ? true : false,
                onChanged: (value) {
                  bloc.add(
                    ChangedCardMode(value: value),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<CardEditorBloc, CardEditorState>(
                builder: (context, state) => AdaptiveButton(
                  onPressed: state.isValid && !state.inProcces
                      ? () {
                          bloc.add(TryAdding());
                          widget.onTap(
                            state.card,
                          );
                          Navigator.of(context).pop();
                        }
                      : null,
                  label: widget.card == null
                      ? SLocale.of(context).add
                      : SLocale.of(context).save,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Platform.isAndroid || Platform.isIOS
          ? Scaffold(
              resizeToAvoidBottomInset: false,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _title(false),
                  Expanded(child: _body()),
                ],
              ),
            )
          : AlertDialog(
              titlePadding: const EdgeInsets.all(10),
              backgroundColor: Theme.of(context).primaryColor,
              contentPadding: EdgeInsets.zero,
              title: _title(true),
              content: _body(),
            ),
    );
  }
}
