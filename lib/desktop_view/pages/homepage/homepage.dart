import 'package:bracket_card_app/components/custom_app_bar/custom_app_bar.dart';
import 'package:bracket_card_app/components/adaptive_button.dart';
import 'package:bracket_card_app/components/label_with_icon.dart';
import 'package:bracket_card_app/desktop_view/modal_windows/card_box_editor/card_box_editor.dart';
import 'package:bracket_card_app/desktop_view/pages/homepage/homepage_bloc.dart';
import 'package:bracket_card_app/desktop_view/pages/homepage/homepage_event.dart';
import 'package:bracket_card_app/desktop_view/pages/homepage/homepage_state.dart';
import 'package:bracket_card_app/generated/l10n.dart';
import 'package:bracket_card_app/navigation/route.dart';
import 'package:client_database/client_database.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../components/card_box_widget.dart';
import '../../../components/error_messager/error_messager.dart';
import '../../modal_windows/show_animated_dialog.dart';

class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({
    super.key,
  });

  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  late HomePageBloc bloc;

  @override
  void initState() {
    bloc = HomePageBloc()..add(HomePageOpened());
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  void _parseArguments(DataChanged dataChanged, CardBox item) {
    if (dataChanged.dataChanged) {
      if (dataChanged.cardBox != null) {
        bloc.add(
          UpdateCardBox(cardBox: dataChanged.cardBox!),
        );
      } else {
        bloc.add(
          DeleteCardBox(cardBox: item),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: MyAppBar(
          title: SLocale.of(context).boxLibrary,
          haveSearchField: true,
          canGoBack: false,
          onClear: (p0) {
            bloc.add(HomePageOpened());
          },
          onSearch: (p0) {
            bloc.add(SearchingCardBox(searchValue: p0 ?? ''));
          },
        ),
        body: BlocListener<HomePageBloc, HomePageState>(
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
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AdaptiveButton(
                  label: SLocale.of(context).addNewBox,
                  icon: Icons.add,
                  onPressed: () => {
                    showAnimatedDialog(
                      context,
                      CardBoxEditor(
                        showWarning: true,
                        cardBox: null,
                        onTap: (value) {
                          if (value != null) {
                            bloc.add(
                              AddCardBox(cardBox: value),
                            );
                          }
                        },
                      ),
                    ),
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<HomePageBloc, HomePageState>(
                    builder: (contex, state) => Visibility(
                      visible: state.searchingByTag,
                      child: LabelWithIcon(
                        label: SLocale.of(context).searchByTag,
                        tag: state.searchingTag ?? '',
                        onTap: () {
                          bloc.add(HomePageOpened());
                        },
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<HomePageBloc, HomePageState>(
                      builder: (context, state) => Center(
                        child: state.cardBoxLoading
                            ? const CircularProgressIndicator()
                            : ValueListenableBuilder(
                                valueListenable: state.cardBoxes,
                                builder: (context, value, child) => value
                                        .isEmpty
                                    ? const Text('Здесь пока ничего нет')
                                    : GridView.builder(
                                        gridDelegate:
                                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 300,
                                          crossAxisSpacing: 40,
                                          mainAxisSpacing: 30,
                                        ),
                                        itemBuilder: (context, index) {
                                          final item = value.elementAt(index);
                                          return CardBoxWidget(
                                            cardBox: item,
                                            changedAddedToFavorites:
                                                (isAddedToFavorites) {
                                              bloc.add(ChangeAddToFavorite(
                                                cardBox: item,
                                                isAdded: isAddedToFavorites,
                                              ));
                                            },
                                            onSearchingByTag: (p0) {
                                              bloc.add(
                                                SearchingCardBoxByTag(
                                                    searchValue: p0),
                                              );
                                            },
                                            onTap: () async {
                                              final args = await context.push(
                                                AppRoute.cardBoxInfo.path,
                                                extra: item,
                                              );
                                              if (args is DataChanged) {
                                                _parseArguments(args, item);
                                              }
                                            },
                                          );
                                        },
                                        itemCount: value.length,
                                        clipBehavior: Clip.antiAlias,
                                      ),
                              ),
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

class DataChanged {
  bool dataChanged = false;
  CardBox? cardBox;
  DataChanged(this.dataChanged, {this.cardBox});
}
