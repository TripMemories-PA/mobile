import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import 'api/auth/auth_service.dart';
import 'bloc/auth_bloc/auth_bloc.dart';
import 'bloc/auth_bloc/auth_event.dart';
import 'bloc/auth_bloc/auth_state.dart';
import 'bloc/cart/cart_bloc.dart';
import 'components/scaffold_with_nav_bar.dart';
import 'constants/route_name.dart';
import 'constants/transitions.dart';
import 'local_storage/secure_storage/auth_token_handler.dart';
import 'object/city.dart';
import 'object/map_style.dart';
import 'object/marker_icons_custom.dart';
import 'object/poi/poi.dart';
import 'object/profile.dart';
import 'page/chat_page.dart';
import 'page/city_page.dart';
import 'page/edit_tweet_page.dart';
import 'page/feed_page.dart';
import 'page/map_page.dart';
import 'page/map_page_user_connected.dart';
import 'page/monument_page_v2.dart';
import 'page/payment_sheet_screen.dart';
import 'page/profile_page.dart';
import 'page/profile_page_poi.dart';
import 'page/quizz_page.dart';
import 'page/scan_qrcode_page.dart';
import 'page/search_page.dart';
import 'page/shop_page.dart';
import 'page/splash_page.dart';
import 'repository/city/cities_repository.dart';
import 'repository/comment/comment_repository.dart';
import 'repository/monument/monument_repository.dart';
import 'repository/post/post_repository.dart';
import 'repository/profile/profile_repository.dart';
import 'repository/quiz/quiz_repository.dart';
import 'repository/ticket/ticket_repository.dart';
import 'service/cities/cities_remote_data_source.dart';
import 'service/comment/comment_remote_data_source.dart';
import 'service/monument/monument_remote_data_source.dart';
import 'service/post/post_remote_data_source.dart';
import 'service/profile/profile_remote_data_source.dart';
import 'service/quiz/quiz_remote_data_source.dart';
import 'service/ticket/tickets_remote_data_source.dart';
import 'theme_generator.dart';
import 'utils/messenger.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MarkerIconsCustom.initialize();
  await MapStyle.initialize();
  Stripe.publishableKey = '{STRIPE_PUBLISHABLE_KEY}';
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied ||
      permission == LocationPermission.deniedForever) {
    permission = await Geolocator.requestPermission();
  }
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => CityRepository(
            citiesRemoteDataSource: CityRemoteDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => MonumentRepository(
            monumentRemoteDataSource: MonumentRemoteDataSource(),
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
          ),
        ),
        RepositoryProvider(
          create: (context) => TicketRepository(
            ticketRemoteDataSource: TicketRemoteDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => QuizRepository(
            quizRemoteDataSource: QuizRemoteDataSource(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authService: AuthService(),
              authTokenHandler: AuthTokenHandler(),
            ),
          ),
          BlocProvider(
            create: (context) => CartBloc(),
          ),
        ],
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
              GoRoute(
                path: RouteName.buy,
                pageBuilder: (context, state) {
                  final CartBloc? cartBloc = state.extra as CartBloc?;
                  if (cartBloc == null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.go(RouteName.searchPage);
                    });
                    return CustomTransitionPage(
                      child: const SizedBox.shrink(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return CustomTransition.buildFadeTransition(
                          animation,
                          child,
                        );
                      },
                    );
                  }
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: PaymentScreen(cartBloc: cartBloc),
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
                    BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return context.read<AuthBloc>().state.status ==
                            AuthStatus.authenticated
                        ? (context.read<AuthBloc>().state.user?.userTypeId == 3
                            ? const SizedBox.shrink()
                            : const MapPageUserConnected())
                        : const MapPage();
                  },
                ),
              ),
              GoRoute(
                path: '${RouteName.monumentPage}/:monumentId',
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: MonumentPageV2(
                      monumentId:
                          int.parse(state.pathParameters['monumentId']!),
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
                path: '${RouteName.quizPage}/:monumentId',
                pageBuilder: (context, state) {
                  final int? monumentId =
                      int.tryParse(state.pathParameters['monumentId'] ?? '');
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: QuizPage(
                      monumentId: monumentId,
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

  final GoRouter _poiRouter = GoRouter(
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
                path: RouteName.shopPage,
                builder: (BuildContext context, GoRouterState state) =>
                    const ShopPage(),
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
              GoRoute(
                path: '${RouteName.monumentPage}/:monumentId',
                pageBuilder: (context, state) {
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: MonumentPageV2(
                      monumentId:
                          int.parse(state.pathParameters['monumentId']!),
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
                path: RouteName.qrCodeScanner,
                builder: (BuildContext context, GoRouterState state) =>
                    const ScanQrcodePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RouteName.profilePagePoi,
                builder: (BuildContext context, GoRouterState state) {
                  return const ProfilePagePoi();
                },
              ),
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
          routerConfig: state.user?.userTypeId == 3 ? _poiRouter : _router,
          theme: ThemeGenerator.generate(),
        );
      },
    );
  }
}
