import 'dart:io';

import 'package:bracket_card_app/generated/l10n.dart';
import 'package:bracket_card_app/utils/models/user_avatar.dart';
import 'package:bracket_card_app/utils/repositories/authorization_repository.dart';
import 'package:bracket_card_app/utils/repositories/card_and_cardbox_repository.dart';
import 'package:client_database/client_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../components/left_navigation_panel/left_nav_panel.dart';
import '../route.dart';
import '../../theme/theme.dart';

class NavigationShell extends StatefulWidget {
  const NavigationShell({
    required this.navigationShell,
    required super.key,
  });
  final StatefulNavigationShell navigationShell;

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  late final LeftNavigationPanelController drawerController;

  @override
  void initState() {
    super.initState();
    drawerController = LeftNavigationPanelController(
      selectedIndex: 0,
      extended: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
    drawerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: (Platform.isAndroid || Platform.isIOS)
          ? BottomNavigationBar(
              backgroundColor: Theme.of(context).primaryColor,
              unselectedIconTheme: IconThemeData(color: AppColors.white),
              items: [
                BottomNavigationBarItem(
                    icon: const Icon(Icons.home),
                    label: SLocale.of(context).home,
                    backgroundColor: Theme.of(context).primaryColor),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite),
                  label: SLocale.of(context).favorite,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings),
                  label: SLocale.of(context).settings,
                ),
                BottomNavigationBarItem(
                  icon: IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: () {
                      GetIt.I<AuthorizationRepository>().logOut();
                      context.go(AppRoute.auth.path);
                    },
                  ),
                  label: SLocale.of(context).exit,
                )
              ],
              currentIndex: widget.navigationShell.currentIndex,
              onTap: (int index) => _onTap(index),
              selectedItemColor: Colors.amber[800],
            )
          : null,
      body: Row(
        mainAxisAlignment: (Platform.isAndroid || Platform.isIOS)
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          !(Platform.isAndroid || Platform.isIOS)
              ? LeftNavigationPanel(
                  controller: drawerController,
                  theme: LeftNavigationPanelTheme(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hoverTextStyle:
                        AppTextStyles.headerStyle2.copyWith(fontSize: 16),
                    selectedTextStyle:
                        AppTextStyles.headerStyle2.copyWith(fontSize: 16),
                    hoverColor: Theme.of(context).primaryColorDark,
                    textStyle:
                        AppTextStyles.headerStyle2.copyWith(fontSize: 16),
                    itemDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    selectedItemDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            Theme.of(context).primaryColorDark.withOpacity(0.3),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColorLight,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.28),
                          blurRadius: 20,
                        )
                      ],
                    ),
                    iconTheme: IconThemeData(
                      color: Colors.white.withOpacity(0.7),
                      size: 20,
                    ),
                    selectedIconTheme: const IconThemeData(
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  extendedTheme: const LeftNavigationPanelTheme(
                    width: 180,
                  ),
                  headerBuilder: (context, extended) {
                    return SizedBox(
                      height: 120,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ValueListenableBuilder<UserAvatar?>(
                              valueListenable:
                                  GetIt.I<CardandCardBoxRepository>()
                                      .userAvatar,
                              builder: ((
                                BuildContext context,
                                UserAvatar? value,
                                child,
                              ) =>
                                  IconButton(
                                    icon: value == null
                                        ? Image.asset(
                                            'assets/images/user_man.png',
                                            width: extended ? 75 : 50,
                                          )
                                        : ClipOval(
                                            child: Image.network(
                                              value.path,
                                              width: extended ? 75 : 50,
                                            ),
                                          ),
                                    iconSize: extended ? 40 : 20,
                                    onPressed: () {
                                      /*  showAnimatedDialog(
                                  context,
                                  const UserInfo(),
                                );*/
                                    },
                                  )),
                            ),
                            if (extended)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: ValueListenableBuilder<User?>(
                                  valueListenable:
                                      GetIt.I<AuthorizationRepository>()
                                          .activeUser,
                                  builder: ((
                                    context,
                                    value,
                                    child,
                                  ) =>
                                      Text(
                                        value?.name.toString() ?? '',
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.center,
                                        softWrap: true,
                                        maxLines: 2,
                                        style: AppTextStyles.headerStyle2
                                            .copyWith(fontSize: 12),
                                      )),
                                ),
                              )
                          ],
                        ),
                      ),
                    );
                  },
                  items: [
                    LeftNavigationPanelItemModel(
                      icon: Icons.home,
                      label: SLocale.of(context).home,
                      onTap: () => _onTap(drawerController.selectedIndex),
                    ),
                    LeftNavigationPanelItemModel(
                      icon: Icons.favorite,
                      label: SLocale.of(context).favorite,
                      onTap: () => _onTap(drawerController.selectedIndex),
                    ),
                    LeftNavigationPanelItemModel(
                      icon: Icons.settings,
                      label: SLocale.of(context).settings,
                      onTap: () => _onTap(drawerController.selectedIndex),
                    ),
                  ],
                  exitItem: LeftNavigationPanelItemModel(
                      icon: Icons.exit_to_app,
                      label: SLocale.of(context).exit,
                      onTap: () {
                        GetIt.I<AuthorizationRepository>().logOut();
                        context.go(AppRoute.auth.path);
                      }),
                )
              : const SizedBox(),
          Expanded(
            flex: 1,
            child: widget.navigationShell,
          ),
        ],
      ),
    );
  }

  void _onTap(int index) {
    widget.navigationShell.goBranch(index);
  }
}
