import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_memories_mobile/page/chat_page.dart';
import 'package:trip_memories_mobile/page/home_page.dart';
import 'package:trip_memories_mobile/page/profile_page.dart';
import 'package:trip_memories_mobile/page/root_page.dart';
import 'package:trip_memories_mobile/page/settings_page.dart';

import '../components/scaffold_with_nav_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionANavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/settings',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state,
          StatefulNavigationShell navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/settings',
              builder: (BuildContext context, GoRouterState state) =>
                  const RootScreen(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'settings',
                  builder: (BuildContext context, GoRouterState state) =>
                      const SettingsPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/chat',
              builder: (BuildContext context, GoRouterState state) =>
                  const RootScreen(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'chat',
                  builder: (BuildContext context, GoRouterState state) =>
                      const ChatPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/home',
              builder: (BuildContext context, GoRouterState state) =>
                  const RootScreen(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'home',
                  builder: (BuildContext context, GoRouterState state) =>
                      const HomePage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/profile',
              builder: (BuildContext context, GoRouterState state) =>
                  const RootScreen(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'details',
                  builder: (BuildContext context, GoRouterState state) =>
                      const ProfilePage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
