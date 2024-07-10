import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/profile/profile_service.dart';
import '../bloc/user_searching_bloc/user_searching_bloc.dart';
import '../component/ranking_body.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
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
      child: const _RankingPageContent(),
    );
  }
}

class _RankingPageContent extends HookWidget {
  const _RankingPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final searching = useState(false);
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
    return RefreshIndicator(
      onRefresh: () async {
        context.read<UserSearchingBloc>().add(
              GetUsersRanking(
                isRefresh: true,
              ),
            );
      },
      child: Column(
        children: [
          _buildHeader(),
          20.ph,
          Expanded(
              child: RankingBody(
            rankingScrollController: rankingScrollController,
          )),
        ],
      ),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Text(
            StringConstants().ranking,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
