import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'api/auth/auth_service.dart';
import 'bloc/auth_bloc/auth_bloc.dart';
import 'bloc/notifier_bloc/notifier_bloc.dart';
import 'component/my_friends_component.dart';
import 'component/my_post_component.dart';
import 'components/scaffold_with_nav_bar.dart';
import 'constants/route_name.dart';
import 'local_storage/secure_storage/auth_token_handler.dart';
import 'page/feed_page.dart';
import 'page/map_page.dart';
import 'page/profile_page.dart';
import 'page/search_page.dart';
import 'page/shop_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionANavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');
final GlobalKey<NavigatorState> _profileNavigationKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteName.searchPage,
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _sectionANavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: RouteName.searchPage,
                builder: (BuildContext context, GoRouterState state) =>
                    const SearchPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RouteName.mapPage,
                builder: (BuildContext context, GoRouterState state) =>
                    const MapPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RouteName.feedPage,
                builder: (BuildContext context, GoRouterState state) =>
                    const FeedPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RouteName.shopPage,
                builder: (BuildContext context, GoRouterState state) =>
                    const ShopPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              StatefulShellRoute.indexedStack(
                builder: (
                  BuildContext context,
                  GoRouterState state,
                  StatefulNavigationShell navigationShell,
                ) {
                  return ProfilePage(navigationShell: navigationShell);
                },
                branches: <StatefulShellBranch>[
                  StatefulShellBranch(
                    navigatorKey: _profileNavigationKey,
                    routes: <RouteBase>[
                      GoRoute(
                        path: RouteName.myFriends,
                        builder: (BuildContext context, GoRouterState state) =>
                            const MyFriendsComponent(),
                      ),
                    ],
                  ),
                  StatefulShellBranch(
                    routes: <RouteBase>[
                      GoRoute(
                        path: RouteName.myPosts,
                        builder: (BuildContext context, GoRouterState state) =>
                            const MyPostsComponents(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authService: AuthService(),
            authTokenHandler: AuthTokenHandler(),
          ),
        ),
        BlocProvider<NotifierBloc>(
          create: (_) => NotifierBloc(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Flutter PA',
        routerConfig: _router,
      ),
    );
  }
}
