import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_event.dart';
import '../constants/route_name.dart';

class SplashPage extends HookWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<AuthBloc>().add(AppStarted());
          Future.delayed(const Duration(seconds: 3), () {
            if (context.mounted) {
              context.go(
                context.read<AuthBloc>().state.user?.userTypeId == 3
                    ? RouteName.shopPage
                    : RouteName.searchPage,
              );
            }
          });
        });

        return null;
      },
      const [],
    );
    return Scaffold(
      body: Center(child: Image.asset('assets/images/splash.png')),
    );
  }
}
