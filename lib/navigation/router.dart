import 'package:bracket_card_app/desktop_view/pages/authorization-page/auth_view.dart';
import 'package:bracket_card_app/desktop_view/pages/card_box_info_page/card_box_info_view.dart';
import 'package:bracket_card_app/desktop_view/pages/cards_page/cards_page_view.dart';
import 'package:bracket_card_app/desktop_view/pages/favorites_page/favorites_page_view.dart';
import 'package:bracket_card_app/desktop_view/pages/homepage/homepage.dart';
import 'package:bracket_card_app/desktop_view/pages/learning_page/learning_page_view.dart';
import 'package:bracket_card_app/desktop_view/pages/settings_page/settings_view.dart';

import 'package:bracket_card_app/utils/repositories/authorization_repository.dart';
import 'package:client_database/client_database.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:go_router/go_router.dart';

import '../utils/repositories/card_and_cardbox_repository.dart';
import 'controller/navigation_shell.dart';
import 'route.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoute.auth.path,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => NavigationShell(
        key: const GlobalObjectKey('NAvigationPageKey'),
        navigationShell: navigationShell,
      ),
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          initialLocation: AppRoute.home.path,
          routes: [
            GoRoute(
              path: AppRoute.home.path,
              builder: (context, state) => const DesktopHomePage(),
            ),
            GoRoute(
              path: AppRoute.cardBoxInfo.path,
              builder: (context, state) =>
                  CardBoxInfoPage(cardBox: state.extra as CardBox),
            ),
            GoRoute(
              path: AppRoute.learning.path,
              builder: (context, state) => LearningPage(
                box: (state.extra as (Duration, CardBox)).$2,
                timeSet: (state.extra as (Duration, CardBox)).$1,
              ),
            ),
            GoRoute(
              path: AppRoute.cardsPage.path,
              builder: (context, state) => CardsPage(
                cardBox: state.extra as CardBox,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: AppRoute.favorites.path,
                builder: (context, state) => const FavoritesPage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoute.settings.path,
              builder: (context, state) => const SettingsPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoute.auth.path,
      name: AppRoute.auth.name,
      builder: (context, state) => const AuthorizationPage(),
      redirect: (context, state) async {
        final isLoggedIn =
            GetIt.instance<AuthorizationRepository>().isUserAuthorized();
        if (isLoggedIn && state.path == AppRoute.auth.path) {
          await GetIt.instance<CardandCardBoxRepository>().init();
          return AppRoute.home.path;
        }

        return null;
      },
    ),
  ],
);
