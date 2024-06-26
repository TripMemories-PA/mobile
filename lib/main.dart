import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import 'api/auth/auth_service.dart';
import 'bloc/auth_bloc/auth_bloc.dart';
import 'bloc/auth_bloc/auth_event.dart';
import 'bloc/auth_bloc/auth_state.dart';
import 'components/scaffold_with_nav_bar.dart';
import 'constants/route_name.dart';
import 'constants/transitions.dart';
import 'local_storage/secure_storage/auth_token_handler.dart';
import 'object/city/city.dart';
import 'object/map_style.dart';
import 'object/marker_icons_custom.dart';
import 'object/poi/poi.dart';
import 'object/profile/profile.dart';
import 'page/chat_page.dart';
import 'page/city_page.dart';
import 'page/edit_tweet_page.dart';
import 'page/feed_page.dart';
import 'page/map_page.dart';
import 'page/monument_page_v2.dart';
import 'page/profile_page.dart';
import 'page/search_page.dart';
import 'page/splash_page.dart';
import 'repository/city/cities_repository.dart';
import 'repository/comment/comment_repository.dart';
import 'repository/monument/monument_repository.dart';
import 'repository/post/post_repository.dart';
import 'repository/profile/profile_repository.dart';
import 'service/cities/cities_remote_data_source.dart';
import 'service/comment/comment_remote_data_source.dart';
import 'service/monument/monument_remote_data_source.dart';
import 'service/post/post_remote_data_source.dart';
import 'service/profile/profile_remote_data_source.dart';
import 'theme_generator.dart';
import 'utils/messenger.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MarkerIconsCustom.initialize();
  await MapStyle.initialize();
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => CityRepository(
            citiesRemoteDataSource: CityRemoteDataSource(),
            // TODO(nono): Implement ProfileLocalDataSource
            //profilelocalDataSource: ProfileLocalDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => MonumentRepository(
            monumentRemoteDataSource: MonumentRemoteDataSource(),
            // TODO(nono): Implement ProfileLocalDataSource
            //profilelocalDataSource: ProfileLocalDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => PostRepository(
            postRemoteDataSource: PostRemoteDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => CommentRepository(
            CommentRemoteDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => ProfileRepository(
            profileRemoteDataSource: ProfileRemoteDataSource(),
            // TODO(nono): Implement ProfileLocalDataSource
            //profilelocalDataSource: ProfileLocalDataSource(),
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => AuthBloc(
          authService: AuthService(),
          authTokenHandler: AuthTokenHandler(),
        ),
        child: MyApp(),
      ),
    ),
  );
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
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: const SearchPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return CustomTransition.buildFadeTransition(
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
                path: RouteName.mapPage,
                builder: (BuildContext context, GoRouterState state) =>
                    const MapPage(),
              ),
              GoRoute(
                path: '${RouteName.monumentPage}/:monumentId',
                pageBuilder: (context, state) {
                  final Poi poi = state.extra! as Poi;
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: MonumentPageV2(
                      monument: poi,
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return CustomTransition.buildBottomToTopPopTransition(
                        animation,
                        child,
                      );
                    },
                  );
                },
              ),
              GoRoute(
                path: '${RouteName.cityPage}/:cityId',
                pageBuilder: (context, state) {
                  final City city = state.extra! as City;
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: CityPage(
                      city: city,
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return CustomTransition.buildBottomToTopPopTransition(
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
                path: RouteName.feedPage,
                builder: (BuildContext context, GoRouterState state) =>
                    const FeedPage(),
              ),
              GoRoute(
                path: RouteName.editTweetPage,
                pageBuilder: (context, state) {
                  final extra = state.extra;
                  final Poi? poi = extra is Poi ? extra : null;
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: EditTweetPage(
                      preSelectedMonument: poi,
                    ),
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
          /*StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RouteName.shopPage,
                builder: (BuildContext context, GoRouterState state) =>
                    const ShopPage(),
              ),
            ],
          ),*/
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
                  final int? userId = int.tryParse(queryParameters['userId']!);
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final GlobalKey<ScaffoldMessengerState> messengerKey =
        useMemoized(GlobalKey<ScaffoldMessengerState>.new, <Object?>[]);
    context.read<AuthBloc>().add(AppStarted());
    useEffect(
      () {
        Messenger.setMessengerKey(messengerKey);
        return null;
      },
      <Object?>[],
    );

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: messengerKey,
          title: 'Trip memories',
          routerConfig: _router,
          theme: ThemeGenerator.generate(),
        );
      },
    );
  }
}
