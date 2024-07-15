import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import 'api/auth/auth_service.dart';
import 'bloc/auth_bloc/auth_bloc.dart';
import 'bloc/auth_bloc/auth_event.dart';
import 'bloc/auth_bloc/auth_state.dart';
import 'bloc/cart/cart_bloc.dart';
import 'bloc/meet/meet_bloc.dart';
import 'bloc/profile/profile_bloc.dart';
import 'component/popup/modify_user_infos_popup.dart';
import 'components/scaffold_with_nav_bar.dart';
import 'components/scaffold_with_nav_bar_poi.dart';
import 'constants/route_name.dart';
import 'constants/transitions.dart';
import 'dto/conversation/conversation_dto.dart';
import 'dto/meet_bloc_and_obj_dto.dart';
import 'local_storage/secure_storage/auth_token_handler.dart';
import 'object/city.dart';
import 'object/map_style.dart';
import 'object/marker_icons_custom.dart';
import 'object/poi/poi.dart';
import 'page/chat_page.dart';
import 'page/city_page.dart';
import 'page/edit_meet_page.dart';
import 'page/edit_question_page.dart';
import 'page/edit_tweet_page.dart';
import 'page/feed_page.dart';
import 'page/map_page.dart';
import 'page/map_page_user_connected.dart';
import 'page/meet_details_page.dart';
import 'page/meet_page.dart';
import 'page/monument_page_v2.dart';
import 'page/payment_sheet_screen.dart';
import 'page/profile_page.dart';
import 'page/profile_page_poi.dart';
import 'page/quizz_page.dart';
import 'page/ranking_page.dart';
import 'page/scan_qrcode_page_android.dart';
import 'page/scan_qrcode_page_ios.dart';
import 'page/search_page.dart';
import 'page/shop_page.dart';
import 'page/splash_page.dart';
import 'repository/chat/chat_repository.dart';
import 'repository/city/cities_repository.dart';
import 'repository/comment/comment_repository.dart';
import 'repository/meet/meet_repository.dart';
import 'repository/monument/monument_repository.dart';
import 'repository/post/post_repository.dart';
import 'repository/profile/profile_repository.dart';
import 'repository/quiz/quiz_repository.dart';
import 'repository/ticket/ticket_repository.dart';
import 'service/chat/chat_remote_data_source.dart';
import 'service/cities/cities_remote_data_source.dart';
import 'service/comment/comment_remote_data_source.dart';
import 'service/meet/meet_remote_data_source.dart';
import 'service/monument/monument_remote_data_source.dart';
import 'service/post/post_remote_data_source.dart';
import 'service/profile/profile_remote_data_source.dart';
import 'service/quiz/quiz_remote_data_source.dart';
import 'service/ticket/tickets_remote_data_source.dart';
import 'theme_generator.dart';
import 'utils/messenger.dart';

AppLocalizations? localisation;

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GlobalKey<NavigatorState> _rootNavigatorKeyPoi =
    GlobalKey<NavigatorState>(debugLabel: 'root_poi');

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
        RepositoryProvider(
          create: (context) => MeetRepository(
            remoteDataSource: MeetRemoteDataSource(),
          ),
        ),
        RepositoryProvider(
          create: (context) => ChatRepository(
            chatRemoteDataSource: ChatRemoteDataSource(),
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
          localisation = AppLocalizations.of(context);
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
                path: '${RouteName.poiMeet}/:monumentId',
                pageBuilder: (context, state) {
                  final Poi poi = state.extra! as Poi;
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: MeetPage(
                      poi: poi,
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
                path: '${RouteName.meet}/:meetId',
                pageBuilder: (context, state) {
                  final MeetBloc meetBloc = state.extra! as MeetBloc;
                  final int meetId =
                      int.parse(state.pathParameters['meetId'] ?? '');
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: MeetDetailsPage(
                      meetBloc: meetBloc,
                      meetId: meetId,
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
              GoRoute(
                path: RouteName.editMeet,
                pageBuilder: (context, state) {
                  final MeetBlocAndObjDTO dto =
                      state.extra! as MeetBlocAndObjDTO;
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: EditMeetPage(
                      meetBlocAndObjDTO: dto,
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
                path: RouteName.rankingPage,
                builder: (BuildContext context, GoRouterState state) {
                  return const RankingPage();
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
                  final ConversationDto conversationDTO =
                      state.extra! as ConversationDto;
                  return ChatPage(conversationDto: conversationDTO);
                },
              ),
              GoRoute(
                path: RouteName.editProfile,
                builder: (BuildContext context, GoRouterState state) {
                  final ProfileBloc profileBloc = state.extra! as ProfileBloc;
                  return UserInfosFormPopup(profileBloc: profileBloc);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );

  final GoRouter _poiRouter = GoRouter(
    navigatorKey: _rootNavigatorKeyPoi,
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
          return ScaffoldWithNavBarPoi(navigationShell: navigationShell);
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
                    Platform.isAndroid
                        ? const ScanQrcodePageAndroid()
                        : const ScanQrcodePageIos(),
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
                  final ConversationDto conversationDTO =
                      state.extra! as ConversationDto;
                  return ChatPage(conversationDto: conversationDTO);
                },
              ),
              GoRoute(
                path: RouteName.editQuestion,
                builder: (BuildContext context, GoRouterState state) {
                  final EditQuestionDTO editQuestionDTO =
                      state.extra! as EditQuestionDTO;
                  return EditQuestionPage(editQuestionDTO: editQuestionDTO);
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
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
