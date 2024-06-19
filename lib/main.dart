import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import 'api/auth/auth_service.dart';
import 'api/monument/model/response/poi/poi.dart';
import 'bloc/auth_bloc/auth_bloc.dart';
import 'components/scaffold_with_nav_bar.dart';
import 'constants/route_name.dart';
import 'constants/transitions.dart';
import 'local_storage/secure_storage/auth_token_handler.dart';
import 'object/post/post.dart';
import 'object/profile/profile.dart';
import 'page/chat_page.dart';
import 'page/edit_tweet_page.dart';
import 'page/feed_page.dart';
import 'page/map_page.dart';
import 'page/monument_page.dart';
import 'page/profile_page.dart';
import 'page/search_page.dart';
import 'page/shop_page.dart';
import 'page/splash_page.dart';
import 'theme_generator.dart';
import 'utils/messenger.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

void main() {
  runApp(MyApp());
}

class MyApp extends HookWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteName.splashPage,
    routes: <RouteBase>[
      GoRoute(
        path: RouteName.splashPage,
        builder: (BuildContext context, GoRouterState state) {
          return const SplashPage();
        },
      ),
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
              GoRoute(
                path: '${RouteName.monumentPage}/:monumentId',
                builder: (context, state) {
                  final Poi poi = state.extra! as Poi;

                  return MonumentPage(
                    monument: poi,
                  );
                },
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
              GoRoute(
                path: RouteName.editTweetPage,
                pageBuilder: (context, state) {
                  final Post? post = state.extra as Post?;
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: EditTweetPage(post: post),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return CustomTransition.buildRightToLeftPopTransition(
                        animation,
                        child,
                      );
                    },
                  );
                },
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
              GoRoute(
                path: '${RouteName.chatPage}/:userId',
                builder: (BuildContext context, GoRouterState state) {
                  final Profile user = state.extra! as Profile;
                  return ChatPage(user: user);
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
    final GlobalKey<ScaffoldMessengerState> messengerKey =
        useMemoized(GlobalKey<ScaffoldMessengerState>.new, <Object?>[]);

    useEffect(
      () {
        Messenger.setMessengerKey(messengerKey);
        return null;
      },
      <Object?>[],
    );

    return BlocProvider(
      create: (context) => AuthBloc(
        authService: AuthService(),
        authTokenHandler: AuthTokenHandler(),
      ),
      child: MaterialApp.router(
        scaffoldMessengerKey: messengerKey,
        title: 'Flutter PA',
        routerConfig: _router,
        theme: ThemeGenerator.generate(),
      ),
    );
  }
}
