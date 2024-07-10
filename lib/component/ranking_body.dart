import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../bloc/user_searching_bloc/user_searching_bloc.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/profile.dart';
import 'custom_card.dart';
import 'shimmer/shimmer_post_and_monument_resume.dart';
import 'shimmer/shimmer_post_and_monument_resume_grid.dart';

class RankingBody extends HookWidget {
  const RankingBody({
    super.key,
    required this.rankingScrollController,
  });

  final ScrollController rankingScrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        10.ph,
        Expanded(child: _buildRankingList()),
      ],
    );
  }

  BlocBuilder<UserSearchingBloc, UserSearchingState> _buildRankingList() {
    return BlocBuilder<UserSearchingBloc, UserSearchingState>(
      builder: (context, state) {
        final List<Profile>? users =
            context.read<UserSearchingBloc>().state.users?.data;
        if (users == null) {
          return Text(StringConstants().noData);
        }
        if (state.status == UserSearchingStatus.error) {
          return _buildErrorWidget(context);
        } else if (state.status == UserSearchingStatus.loading) {
          return const Center(child: ShimmerPostAndMonumentResumeGrid());
        } else if (users.isEmpty) {
          return Text(StringConstants().noUserFound);
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: rankingScrollController,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return CustomCard(
                      content: Row(
                        children: [
                          Text(user.score.toString()),
                          Text(user.username),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: context.read<UserSearchingBloc>().state.hasMoreUsers
                    ? (context.read<UserSearchingBloc>().state.status !=
                            UserSearchingStatus.error
                        ? const ShimmerPostAndMonumentResume()
                        : _buildErrorWidget(context))
                    : Text(StringConstants().noMoreUsers),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Column(
      children: [
        Text(StringConstants().errorAppendedWhileGettingData),
        ElevatedButton(
          onPressed: () => _getRankingRequest(context),
          child: Text(StringConstants().retry),
        ),
      ],
    );
  }

  void _getRankingRequest(BuildContext context) {
    context.read<UserSearchingBloc>().add(
          GetUsersRanking(
            isRefresh: true,
          ),
        );
  }
}
