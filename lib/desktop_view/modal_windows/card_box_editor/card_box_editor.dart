import 'package:bracket_card_app/components/adaptive_button.dart';
import 'package:bracket_card_app/components/card_box_widget.dart';
import 'package:bracket_card_app/components/modal_window_title/modal_window_title.dart';
import 'package:bracket_card_app/components/text_field.dart';
import 'package:bracket_card_app/desktop_view/modal_windows/card_box_editor/card_box_editor_bloc.dart';
import 'package:bracket_card_app/desktop_view/modal_windows/card_box_editor/card_box_editor_event.dart';
import 'package:bracket_card_app/desktop_view/modal_windows/card_box_editor/card_box_editor_state.dart';
import 'package:bracket_card_app/theme/theme.dart';
import 'package:client_database/client_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import '../../../components/switch.dart';
import '../../../generated/l10n.dart';

class CardBoxEditor extends StatefulWidget {
  const CardBoxEditor({
    super.key,
    required this.onTap,
    required this.cardBox,
    required this.showWarning,
  });
  final bool showWarning;
  final CardBox? cardBox;
  final void Function(CardBox?) onTap;

  @override
  State<CardBoxEditor> createState() => _CardBoxEditorState();
}

class _CardBoxEditorState extends State<CardBoxEditor> {
  late CardBoxEditorBloc bloc;
  @override
  void initState() {
    bloc = CardBoxEditorBloc()
      ..add(
        widget.cardBox == null
            ? CreatorOpened()
            : EditorOpened(
                cardBox: widget.cardBox!,
              ),
      );
    super.initState();
  }

  Widget _title(bool isDesktopView) {
    return ValueListenableBuilder(
      valueListenable: bloc.dataChanged,
      builder: (context, value, child) => ModalWindowTitle(
        desktopView: isDesktopView,
        checkDataPersistence: widget.showWarning ? value : false,
        title: widget.cardBox == null
            ? SLocale.of(context).boxCreating
            : SLocale.of(context).boxEditting,
        icon: widget.cardBox == null
            ? const Icon(
                Icons.create,
                color: AppColors.white,
              )
            : const Icon(
                Icons.edit,
                color: AppColors.white,
              ),
      ),
    );
  }

  Widget _body() {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 300,
                height: 300,
                child: BlocBuilder<CardBoxEditorBloc, CardBoxEditorState>(
                    builder: (context, state) {
                  return CardBoxWidget(
                    cardBox: state.cardbox,
                    onEdditing: true,
                    onDeleteTagLabel: (p0) {
                      bloc.add(
                        DeletedCategory(index: p0),
                      );
                    },
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextField(
                  hint: SLocale.of(context).boxName,
                  initialValue:
                      widget.cardBox != null ? widget.cardBox!.boxName : '',
                  tooltip: SLocale.of(context).clear,
                  helperText: SLocale.of(context).boxNameHintText,
                  onTapSuffixIcon: (p0) {
                    bloc.add(
                      ChangedBoxName(name: ''),
                    );
                  },
                  clearSuffixIcon: Icons.clear,
                  onChanged: (p0) => bloc.add(
                    ChangedBoxName(name: p0),
                  ),
                  validator: (p0) => bloc.isBoxNameValid(p0 ?? ''),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 300,
                          child: CustomTextField(
                            hint: SLocale.of(context).category,
                            helperText: SLocale.of(context).categoryHintText,
                            tooltip: SLocale.of(context).add,
                            onChanged: (p0) {},
                            isAddingTextField: true,
                            clearSuffixIcon: Icons.add,
                            onTapSuffixIcon: (p0) {
                              bloc.add(
                                AddNewCategory(
                                  newCategory: p0!,
                                ),
                              );
                            },
                            validator: (p0) => bloc.isCategoryValid(p0 ?? ''),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSwitch(
                  tooltip: SLocale.of(context).isPrivateToolTip,
                  iconSelected: Icons.lock,
                  iconBase: Icons.public,
                  label: SLocale.of(context).isPrivate,
                  value: widget.cardBox?.private ?? false,
                  onChanged: (value) {
                    bloc.add(
                      ChangePrivate(value: value),
                    );
                  },
                ),
              ),
              BlocBuilder<CardBoxEditorBloc, CardBoxEditorState>(
                builder: (context, state) => AdaptiveButton(
                  onPressed: state.isValid && !state.inProcces
                      ? () {
                          bloc.add(TryAdding());
                          widget.onTap(state.cardbox);
                          Navigator.of(context).pop();
                        }
                      : null,
                  label: widget.cardBox == null
                      ? SLocale.of(context).add
                      : SLocale.of(context).save,
                ),
              )
            ],
          ),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _title(false),
                  _body(),
                ],
              ),
            )
          : AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              title: _title(true),
              content: _body(),
            ),
    );
  }
}
