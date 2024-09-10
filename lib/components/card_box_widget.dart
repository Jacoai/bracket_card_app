import 'package:bracket_card_app/components/tag_label.dart';
import 'package:bracket_card_app/theme/theme.dart';
import 'package:bracket_card_app/utils/repositories/authorization_repository.dart';
import 'package:bracket_card_app/utils/repositories/card_and_cardbox_repository.dart';
import 'package:client_database/client_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class CardBoxWidget extends StatelessWidget {
  const CardBoxWidget({
    super.key,
    required this.cardBox,
    this.onDeleteTagLabel,
    this.onEdditing = false,
    this.onTap,
    this.onSearchingByTag,
    this.changedAddedToFavorites,
  });
  final CardBox cardBox;
  final bool onEdditing;
  final void Function()? onTap;
  final void Function(int)? onDeleteTagLabel;
  final void Function(String)? onSearchingByTag;
  final void Function(bool)? changedAddedToFavorites;

  bool _canAddToFavorites() {
    return !onEdditing &&
        GetIt.instance<AuthorizationRepository>().activeUser.value!.name !=
            cardBox.author;
  }

  bool _getIsAddedToFavorites() {
    return GetIt.instance<CardandCardBoxRepository>()
            .findCardBoxInDb(cardBox) !=
        null;
  }

  Future<int> _getNumberOfLearnedCard() async {
    return await GetIt.instance<CardandCardBoxRepository>()
        .getNumberOfLearnedCard(cardBox);
  }

  @override
  Widget build(BuildContext context) {
    int numOfCards = cardBox.cardIds.isNotEmpty ? cardBox.cardIds.length : 0;

    ValueNotifier<bool> isAddedToFavorites =
        ValueNotifier(_getIsAddedToFavorites());

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double backgroundCardWidth = constraints.maxWidth * 0.95;
              double backgroundCardHeight = constraints.maxHeight;
              double width = constraints.maxWidth;
              double height = constraints.maxHeight * 0.95;
              Color boxColor = Color(int.tryParse(cardBox.color ?? '') ??
                  Theme.of(context).primaryColor.value);
              return GestureDetector(
                onTap: onEdditing ? null : onTap,
                child: Stack(
                  children: [
                    if (numOfCards > 0)
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: backgroundCardWidth,
                          height: backgroundCardHeight,
                          decoration: BoxDecoration(
                            color: Theme.of(context).secondaryHeaderColor,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                          color: boxColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  cardBox.boxName,
                                  style: AppTextStyles.headerStyle2,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: isAddedToFavorites.value ||
                                        !_canAddToFavorites()
                                    ? FutureBuilder(
                                        future: _getNumberOfLearnedCard(),
                                        builder: (context, snapshot) => Text(
                                          "${snapshot.connectionState == ConnectionState.waiting ? '...' : snapshot.data ?? 0}/${cardBox.cardIds.length}",
                                          style: AppTextStyles.accentbaseText,
                                        ),
                                      )
                                    : Text(
                                        "0/${cardBox.cardIds.length}",
                                        style: AppTextStyles.accentbaseText,
                                      ),
                              ),
                              _canAddToFavorites()
                                  ? Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                        onTap: () {
                                          changedAddedToFavorites!(
                                              isAddedToFavorites.value);
                                          isAddedToFavorites.value =
                                              !isAddedToFavorites.value;
                                        },
                                        child: ValueListenableBuilder(
                                          valueListenable: isAddedToFavorites,
                                          builder: (context, value, child) =>
                                              Icon(
                                            value
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: SizedBox(
                                  height: 40,
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    reverse: false,
                                    scrollDirection: Axis.horizontal,
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 4,
                                      direction: Axis.vertical,
                                      children: buildCategoryList(
                                        cardBox.category,
                                        context,
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
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String formatDate(DateTime date) {
    final dateFormatter = DateFormat('dd-MM-yyyy HH:mm');
    return dateFormatter.format(date);
  }

  List<Widget> buildCategoryList(List<String> category, BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < category.length; i++) {
      list.add(
        TagLabel(
          text: category[i],
          color:
              Theme.of(context).extension<ThemeColors>()!.filterButtonFillColor,
          onEdditing: onEdditing,
          onTap: () => onDeleteTagLabel!(i),
          onSearching: onSearchingByTag,
        ),
      );
    }
    return list;
  }
}
