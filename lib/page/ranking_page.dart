import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/profile/profile_service.dart';
import '../bloc/user_searching_bloc/user_searching_bloc.dart';
import '../component/ranking_body.dart';
import '../repository/profile/profile_repository.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserSearchingBloc(
        profileRepository: RepositoryProvider.of<ProfileRepository>(
          context,
        ),
        profileService: ProfileService(),
      )..add(GetUsersRanking(isRefresh: true)),
      child: _RankingPageContent(),
    );
  }
}

class _RankingPageContent extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final ScrollController rankingScrollController = useScrollController();
    useEffect(
      () {
        void createScrollListener() {
          if (rankingScrollController.position.atEdge) {
            if (rankingScrollController.position.pixels != 0) {
              _getRank(context);
            }
          }
        }

        rankingScrollController.addListener(createScrollListener);
        return () =>
            rankingScrollController.removeListener(createScrollListener);
      },
      const [],
    );
    return RankingBody(
      rankingScrollController: rankingScrollController,
    );
  }

  void _getRank(BuildContext context) {
    final profileBloc = context.read<UserSearchingBloc>();

    if (profileBloc.state.status != UserSearchingStatus.loading) {
      profileBloc.add(
        GetUsersRanking(),
      );
    }
  }
}
