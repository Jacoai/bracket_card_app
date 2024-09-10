import 'package:bracket_card_app/components/adaptive_button.dart';
import 'package:bracket_card_app/components/card_list_view.dart';
import 'package:bracket_card_app/components/custom_app_bar/custom_app_bar.dart';

import 'package:bracket_card_app/desktop_view/modal_windows/show_animated_dialog.dart';

import 'package:bracket_card_app/generated/l10n.dart';
import 'package:bracket_card_app/utils/repositories/authorization_repository.dart';
import 'package:client_database/client_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../components/error_messager/error_messager.dart';
import '../../modal_windows/card_editor/card_editor.dart';
import 'cards_page_bloc.dart';
import 'cards_page_event.dart';
import 'cards_page_state.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({
    super.key,
    required this.cardBox,
  });
  final CardBox cardBox;

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  late final CardsPageBloc bloc;
  late bool isMyBox;
  late bool onlyView;

  @override
  void initState() {
    isMyBox = widget.cardBox.author ==
        GetIt.instance<AuthorizationRepository>().activeUser.value!.name;
    bloc = CardsPageBloc()..add(CardsPageOpened(cardBox: widget.cardBox));
    super.initState();

    onlyView = bloc.findBoxInBd(widget.cardBox) ? false : true;
  }

  @override
  Widget build(BuildContext contexdst) {
    final bloc = CardsPageBloc()
      ..add(
        CardsPageOpened(
          cardBox: widget.cardBox,
        ),
      );
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: MyAppBar(
          canGoBack: true,
          title: widget.cardBox.boxName,
          haveSearchField: false,
          onSearch: (p0) {},
          onClear: (p0) {},
          onExit: () {
            context.pop([
              bloc.dataChanged.value,
              bloc.dataChanged.value ? bloc.state.cardBox : null
            ]);
          },
        ),
        body: BlocListener<CardsPageBloc, CardsPageState>(
          listener: (context, state) {
            if (state.message.code != 200) {
              {
                showAnimatedDialog(
                  context,
                  ErrorMesseger(
                      errorName: SLocale.of(context).globalError,
                      errorDescribe: state.message.getMessage()),
                );
                bloc.add(ClearMessage());
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!onlyView)
                      Flexible(child: Text(SLocale.of(context).onlyUnstudied)),
                    if (!onlyView)
                      ValueListenableBuilder(
                        valueListenable: bloc.state.onlyUnstudied,
                        builder: (context, value, child) => Checkbox(
                            value: value,
                            onChanged: (value) {
                              bloc.add(CheckboxChanged(value: value ?? false));
                            }),
                      ),
                    if (isMyBox || !onlyView)
                      AdaptiveButton(
                        label: SLocale.of(context).add,
                        icon: Icons.create,
                        onPressed: () {
                          showAnimatedDialog(
                            context,
                            CardEditor(
                              onTap: (card) {
                                if (card != null) {
                                  bloc.add(
                                    CardAdded(card: card),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: BlocBuilder<CardsPageBloc, CardsPageState>(
                      builder: (context, state) => state.isLoading
                          ? const CircularProgressIndicator()
                          : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 500,
                                crossAxisSpacing: 40,
                                mainAxisSpacing: 30,
                              ),
                              padding: const EdgeInsets.all(15),
                              itemBuilder: (context, index) {
                                final item = state.cards.elementAt(index);
                                return LearningCardGridView(
                                  onSolvedChanged: onlyView
                                      ? null
                                      : (result) {
                                          bloc.add(
                                            CardUpdated(
                                              card: item.copyWith(
                                                  isSolved: !result),
                                            ),
                                          );
                                        },
                                  canEdit: isMyBox,
                                  onDelete: () {
                                    bloc.add(
                                      CardDeleted(card: item),
                                    );
                                  },
                                  onEdit: () {
                                    showAnimatedDialog(
                                      context,
                                      CardEditor(
                                        card: item,
                                        onTap: (card) {
                                          if (card != null) {
                                            bloc.add(
                                              CardUpdated(card: card),
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                  card: item,
                                );
                              },
                              itemCount: state.cards.length,
                              clipBehavior: Clip.antiAlias,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
