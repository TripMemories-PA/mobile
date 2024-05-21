import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:trip_memories_mobile/theme_generator.dart';

import 'api/auth/auth_service.dart';
import 'bloc/auth_bloc/auth_bloc.dart';
import 'bloc/notifier_bloc/notifier_bloc.dart';
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
              GoRoute(
                path: RouteName.profilePage,
                builder: (BuildContext context, GoRouterState state) {
                  return const ProfilePage();
                },
              ),
              GoRoute(
                path: '${RouteName.profilePage}/:userId',
                builder: (BuildContext context, GoRouterState state) {
                  final Map<String, String> queryParameters =
                      GoRouterState.of(context).pathParameters;
                  final String? userId = queryParameters['userId'];
                  return ProfilePage(userId: userId);
                },
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
        theme: ThemeGenerator.generate(),
      ),
    );
  }
}
