import 'package:bracket_card_app/components/custom_app_bar/custom_app_bar.dart';
import 'package:bracket_card_app/components/learning_parameters_form.dart';
import 'package:bracket_card_app/desktop_view/pages/card_box_info_page/card_box_info_bloc.dart';
import 'package:bracket_card_app/desktop_view/pages/homepage/homepage.dart';
import 'package:bracket_card_app/navigation/route.dart';
import 'package:bracket_card_app/theme/theme.dart';
import 'package:bracket_card_app/utils/repositories/authorization_repository.dart';
import 'package:client_database/client_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../components/adaptive_button.dart';
import '../../../components/card_box_widget.dart';
import '../../../components/error_messager/error_messager.dart';
import '../../../generated/l10n.dart';
import '../../modal_windows/card_box_editor/card_box_editor.dart';
import '../../modal_windows/show_animated_dialog.dart';

class CardBoxInfoPage extends StatefulWidget {
  const CardBoxInfoPage({super.key, required this.cardBox});
  final CardBox cardBox;

  @override
  State<CardBoxInfoPage> createState() => _CardBoxInfoPageState();
}

class _CardBoxInfoPageState extends State<CardBoxInfoPage> {
  late CardBoxInfoBloc bloc;
  late bool isMyBox;

  @override
  void initState() {
    bloc = CardBoxInfoBloc()..add(CardBoxInfoLoad(cardBox: widget.cardBox));
    isMyBox =
        GetIt.instance<AuthorizationRepository>().activeUser.value!.name ==
            widget.cardBox.author;
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        canGoBack: true,
        title: SLocale.of(context).boxInfo,
        haveSearchField: false,
        onSearch: (p0) {},
        onClear: (value) {},
        onExit: () {
          context.pop(DataChanged(bloc.state.changed,
              cardBox: bloc.state.changed ? bloc.state.cardBox : null));
        },
      ),
      body: BlocProvider(
        create: (context) => bloc,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 8.0, 8.0, 8.0),
          child: Center(
            child: BlocBuilder<CardBoxInfoBloc, CardBoxInfoState>(
              builder: (context, state) {
                if (state.status == CardBoxInfoLoadStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.status == CardBoxInfoLoadStatus.error) {
                  return Center(
                    child: Text(
                        "${SLocale.of(context).globalError}:${state.errorMsg}"),
                  );
                } else {
                  return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: 400,
                                  maxWidth: 400,
                                ),
                                child: CardBoxWidget(
                                  cardBox: state.cardBox!,
                                  changedAddedToFavorites:
                                      (isAddedToFavorites) {
                                    bloc.add(
                                      CardBoxInfoChangedAddedToFavorites(
                                        cardBox: state.cardBox!,
                                        isAdded: isAddedToFavorites,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "${SLocale.of(context).author}: ${state.cardBox!.author}"),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    "${SLocale.of(context).numOfCardsInBox}: ${state.cardBox!.cardIds.length}"),
                              ),
                              Wrap(
                                spacing: 16,
                                alignment: WrapAlignment.center,
                                children: [
                                  if (isMyBox)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AdaptiveButton(
                                        label: SLocale.of(context).deleteBox,
                                        onPressed: () async {
                                          final answer = await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return ErrorMesseger(
                                                    isWarningMessage: true,
                                                    errorName:
                                                        SLocale.of(context)
                                                            .deleteBoxMessage);
                                              });
                                          if (answer) {
                                            bloc.add(CardBoxInfoDelete(
                                                cardBox: widget.cardBox));
                                            if (context.mounted) {
                                              context.pop(DataChanged(true));
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  if (isMyBox)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AdaptiveButton(
                                        label: SLocale.of(context).editBox,
                                        onPressed: () => showAnimatedDialog(
                                          context,
                                          CardBoxEditor(
                                            showWarning: false,
                                            onTap: (value) {
                                              if (value != null) {
                                                bloc.add(
                                                  CardBoxInfoUpdate(
                                                      cardBox: value),
                                                );
                                              }
                                            },
                                            cardBox: state.cardBox,
                                          ),
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AdaptiveButton(
                                      baseColor: AppColors.accentYellow,
                                      icon: Icons.library_books,
                                      label: MediaQuery.of(context).size.width >
                                              600
                                          ? SLocale.of(context).goToCards
                                          : '',
                                      onPressed: () async {
                                        final args = await context.push(
                                          AppRoute.cardsPage.path,
                                          extra: widget.cardBox,
                                        );
                                        if (args != null) {
                                          args as List<dynamic>;
                                          if (args[0] is bool) {
                                            if (args[0]) {
                                              if (args[1] is CardBox) {
                                                bloc.add(
                                                  CardBoxInfoUpdate(
                                                      cardBox: args[1]),
                                                );
                                              }
                                            }
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          LearningParametersWidget(
                            cardBox: state.cardBox!,
                          )
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
