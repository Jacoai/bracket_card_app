import 'package:bracket_card_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../components/card_box_widget.dart';
import '../../../components/custom_app_bar/custom_app_bar.dart';
import '../../../components/error_messager/error_messager.dart';
import '../../modal_windows/show_animated_dialog.dart';
import 'favorites_page_bloc.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({
    super.key,
  });

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late FavoritesPageBloc bloc;
  @override
  void initState() {
    bloc = FavoritesPageBloc()..add(FavoritesPageOpened());
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FavoritesPage oldWidget) {
    print('UPDATE????');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        appBar: MyAppBar(
          title: SLocale.of(context).favoriteBoxes,
          haveSearchField: true,
          canGoBack: false,
          onClear: (p0) {
            bloc.add(FavoritesPageOpened());
          },
          onSearch: (p0) {
            if (p0 != null && p0.isNotEmpty) {
              bloc.add(SearchingCardBox(searchValue: p0));
            } else {
              bloc.add(FavoritesPageOpened());
            }
          },
        ),
        body: BlocListener<FavoritesPageBloc, FavoritesPageState>(
          listener: (context, state) {
            if (state.message.code != 200) {
              {
                showAnimatedDialog(
                  context,
                  ErrorMesseger(
                      errorName: SLocale.of(context).globalError,
                      errorDescribe: state.message.getMessage()),
                );
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<FavoritesPageBloc, FavoritesPageState>(
                      builder: (context, state) => Center(
                        child: state.loading
                            ? const CircularProgressIndicator()
                            : state.message.message.isNotEmpty
                                ? Text(state.message.message)
                                : ValueListenableBuilder(
                                    valueListenable: bloc.favorites,
                                    builder: (context, value, child) =>
                                        GridView.builder(
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
                                            bloc.add(
                                              DeleteFromFavorites(
                                                cardBox: item,
                                              ),
                                            );
                                          },
                                          onTap: () async {
                                            await context.push(
                                              '/card_box_info',
                                              extra: item,
                                            );
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
