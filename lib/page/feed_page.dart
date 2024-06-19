import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../constants/route_name.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          context.read<AuthBloc>().state.status == AuthStatus.authenticated
              ? FloatingActionButton(
                  onPressed: () => context.push(RouteName.editTweetPage),
                  child: const Icon(Icons.add),
                )
              : null,
      body: const ColoredBox(
        color: Colors.yellow,
        child: Center(
          child: Text('FEED'),
        ),
      ),
    );
  }
}
