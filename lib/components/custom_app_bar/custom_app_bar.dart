import 'package:bracket_card_app/components/text_field.dart';
import 'package:bracket_card_app/generated/l10n.dart';
import 'package:bracket_card_app/theme/theme.dart';
import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    required this.canGoBack,
    required this.title,
    required this.haveSearchField,
    required this.onSearch,
    required this.onClear,
    this.onExit,
  });
  final bool canGoBack;
  final String title;
  final bool haveSearchField;
  final void Function(String?) onSearch;
  final void Function(String?) onClear;
  final void Function()? onExit;
  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(120.0);
}

class _MyAppBarState extends State<MyAppBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  build(BuildContext context) => SizedBox(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (widget.canGoBack)
                      IconButton(
                          onPressed:
                              widget.onExit ?? () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back)),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        widget.title,
                        style: AppTextStyles.headerStyle1.copyWith(
                            color: AppColors.accentYellow, height: 0.8),
                        overflow: TextOverflow.clip,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                if (widget.haveSearchField)
                  SizedBox(
                    height: 60,
                    width: 300,
                    child: CustomTextField(
                      hint: SLocale.of(context).search,
                      onChanged: widget.onSearch,
                      onTapSuffixIcon: widget.onClear,
                      isSearchingField: true,
                    ),
                  )
              ],
            ),
          ),
        ),
      );
}
