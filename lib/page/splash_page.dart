import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../constants/route_name.dart';

class SplashPage extends HookWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        Future.delayed(const Duration(seconds: 3), () {
          context.go(RouteName.searchPage);
        });
        return null;
      },
      const [],
    );
    return SafeArea(
      child: Scaffold(
        body: Image.asset('assets/images/splash.png'),
      ),
    );
  }
}
