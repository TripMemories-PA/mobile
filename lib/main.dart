import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';

import '.env.dart';
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
import 'page/monument_page_v2.dart';
import 'page/payment_sheet_screen.dart';
import 'page/profile_page.dart';
import 'page/search_page.dart';
import 'page/shop_page.dart';
import 'page/splash_page.dart';
import 'repository/city/cities_repository.dart';
import 'repository/comment/comment_repository.dart';
import 'repository/monument/monument_repository.dart';
import 'repository/post/post_repository.dart';
import 'repository/profile/profile_repository.dart';
import 'repository/ticket/ticket_repository.dart';
import 'service/cities/cities_remote_data_source.dart';
import 'service/comment/comment_remote_data_source.dart';
import 'service/monument/monument_remote_data_source.dart';
import 'service/post/post_remote_data_source.dart';
import 'service/profile/profile_remote_data_source.dart';
import 'service/ticket/tickets_remote_data_source.dart';
import 'theme_generator.dart';
import 'utils/messenger.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MarkerIconsCustom.initialize();
  await MapStyle.initialize();
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
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
        RepositoryProvider(
          create: (context) => TicketRepository(
            ticketRemoteDataSource: TicketRemoteDataSource(),
            // TODO(nono): Implement ProfileLocalDataSource
            //profilelocalDataSource: ProfileLocalDataSource(),
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
                    const MapPage(),
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
                redirect: (BuildContext context, GoRouterState state) {
                  final authState = context.read<AuthBloc>().state;
                  final isAuthenticated =
                      authState.status == AuthStatus.authenticated;
                  final isUserType3 = authState.user?.userTypeId == 3;

                  if (isAuthenticated && isUserType3) {
                    return RouteName.shopPage;
                  }
                  return null;
                },
                builder: (BuildContext context, GoRouterState state) =>
                    const FeedPage(),
              ),
              GoRoute(
                path: RouteName.shopPage,
                builder: (BuildContext context, GoRouterState state) =>
                    const ShopPage(),
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

var coucou = {
  'id': 1,
  'usedAt': null,
  'paid': true,
  'qrCode': 'e0d11c06-6a64-49f0-b221-af15b9592d29',
  'ticketId': 2,
  'userId': 1,
  'createdAt': '2024-07-06T14:17:22.222+00:00',
  'updatedAt': '2024-07-06T14:17:22.222+00:00',
  'ticket': {
    'id': 2,
    'title': 'admoveo alo cavus',
    'description':
        'Cohaero coma bonus ante hic quo. Apto minus sumo stillicidium curia vinculum ulterius cena derelinquo. Callide toties debilito defleo aegre quia terreo.',
    'quantity': 67,
    'price': '7.30',
    'groupSize': 10,
    'poiId': 3407,
    'createdAt': '2024-07-06T14:17:21.808+00:00',
    'updatedAt': '2024-07-06T14:17:21.808+00:00',
    'poi': {
      'id': 3407,
      'name': 'Arc de Triomphe',
      'description':
          "Commandé par Napoléon Ier pour célébrer le triomphe de ses armées à la bataille d'Austerlitz, le plus grand arc du monde est érigé entre 1806 et 1836. Depuis 1921, il abrite la tombe du Soldat Inconnu, dont la flamme du souvenir est ravivée tous les soirs. La vue panoramique de la capitale depuis son toit-terrasse est à couper le souffle.",
      'coverId': 3407,
      'typeId': 3,
      'latitude': '48.873831',
      'longitude': '2.295027',
      'cityId': 441,
      'address': 'Place Charles de Gaulle',
      'createdAt': '2024-07-06T14:16:52.015+00:00',
      'updatedAt': '2024-07-06T14:16:52.015+00:00',
      'cover': {
        'id': 3407,
        'filename': 'Arc_de_Triomphe%2C_Paris_21_October_2010.jpg',
        'url':
            'https://upload.wikimedia.org/wikipedia/commons/7/79/Arc_de_Triomphe%2C_Paris_21_October_2010.jpg',
        'mimeType': 'image/jpeg',
        'createdAt': '2024-07-06T14:16:52.015+00:00',
        'updatedAt': '2024-07-06T14:16:52.015+00:00',
      },
      'city': {
        'id': 441,
        'name': 'Paris',
        'zipCode': '75008',
        'coverId': 953,
        'createdAt': '2024-07-06T14:16:31.827+00:00',
        'updatedAt': '2024-07-06T14:16:31.827+00:00',
      },
      'type': {
        'id': 3,
        'name': 'Monument',
        'createdAt': '2024-07-06T14:16:21.354+00:00',
        'updatedAt': '2024-07-06T14:16:21.354+00:00',
      },
    },
  },
  'user': {
    'id': 1,
    'email': 'user1@mail.com',
    'username': 'user1',
    'firstname': 'Lane',
    'lastname': 'Ruecker',
    'userTypeId': 2,
    'createdAt': '2024-07-06T14:17:21.934+00:00',
    'updatedAt': '2024-07-06T14:17:21.934+00:00',
    'avatarId': 6824,
    'bannerId': 6825,
    'poiId': null,
    'score': 415,
    'avatar': {
      'id': 6824,
      'filename': 'modulo_zany_proof_reader.jpg',
      'url': 'https://avatars.githubusercontent.com/u/53536414',
      'mimeType': 'image/jpeg',
      'createdAt': '2024-07-06T14:17:21.888+00:00',
      'updatedAt': '2024-07-06T14:17:21.888+00:00',
    },
    'banner': {
      'id': 6825,
      'filename': 'verbally.jpg',
      'url': 'https://picsum.photos/seed/2KLhj7jh4/640/480',
      'mimeType': 'image/jpeg',
      'createdAt': '2024-07-06T14:17:21.889+00:00',
      'updatedAt': '2024-07-06T14:17:21.889+00:00',
    },
    'userType': {
      'id': 2,
      'name': 'User',
      'createdAt': '2024-07-06T14:17:21.854+00:00',
      'updatedAt': '2024-07-06T14:17:21.854+00:00',
    },
  },
};
