import 'package:go_router/go_router.dart';

import '../page/home_page.dart';
import 'custom_transition.dart';
import 'route_name.dart';

final GoRouter router = GoRouter(
  routes: goRoutes,
);

List<GoRoute> goRoutes = [
  GoRoute(
    path: RouteName.homePage,
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: const HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return CustomTransition.buildFadeTransition(animation, child);
        },
      );
    },
  ),
];
