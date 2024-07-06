import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../component/feed.dart';
import '../component/poi_feed.dart';
import '../constants/route_name.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final int userTypeId = state.user?.userTypeId ?? 0;
        final int poiId = state.user?.poiId ?? 0;
        return SafeArea(
          child: Scaffold(
            floatingActionButton: context.read<AuthBloc>().state.status ==
                        AuthStatus.authenticated &&
                    userTypeId != 3
                ? FloatingActionButton(
                    onPressed: () => context.push(RouteName.editTweetPage),
                    child: const Icon(Icons.add),
                  )
                : null,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: userTypeId == 3
                  ? PoiFeed(monumentId: poiId)
                  : const FeedComponent(),
            ),
          ),
        );
      },
    );
  }
}
