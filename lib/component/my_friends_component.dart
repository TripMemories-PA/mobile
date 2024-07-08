import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile/profile_bloc.dart';
import '../constants/my_colors.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/profile.dart';
import 'custom_card.dart';
import 'popup/my_friends_requests.dart';
import 'popup/user_searching.dart';
import 'shimmer/shimmer_post_and_monument_resume_grid.dart';
import 'user_list.dart';

class MyFriendsComponent extends StatelessWidget {
  const MyFriendsComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomCard(
              onTap: () async {
                await userSearchingPopup(context);
              },
              width: MediaQuery.of(context).size.width * 0.40,
              height: 30,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add,
                    color: MyColors.purple,
                  ),
                  10.pw,
                  Text(
                    StringConstants().addFriend,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              borderColor: MyColors.darkGrey,
              borderRadius: 20,
            ),
            CustomCard(
              onTap: () async {
                await myFriendsRequestsPopup(context);
              },
              width: MediaQuery.of(context).size.width * 0.40,
              height: 30,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.groups_2_outlined,
                    color: MyColors.purple,
                  ),
                  10.pw,
                  Text(
                    StringConstants().manageFriendsRequests,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              borderColor: MyColors.darkGrey,
              borderRadius: 20,
            ),
          ],
        ),
        20.ph,
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (context.read<ProfileBloc>().state.status ==
                ProfileStatus.loading) {
              return SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.60,
                child: const ShimmerPostAndMonumentResumeGrid(),
              );
            } else {
              return _buildFriendsList(context);
            }
          },
        ),
      ],
    );
  }

  Widget _buildFriendsList(BuildContext context) {
    final List<Profile> friends =
        context.read<ProfileBloc>().state.friends.data;
    if (friends.isEmpty) {
      return Center(child: Text(StringConstants().noFriendAdded));
    }
    if (context.read<ProfileBloc>().state.status == ProfileStatus.loading) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.90,
        height: MediaQuery.of(context).size.height * 0.30,
        child: const ShimmerPostAndMonumentResumeGrid(),
      );
    }
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Column(
          children: [
            UserList(
              users: state.friends.data,
              horizontalCellSpacing: 20,
              padding: 20,
            ),
            Center(
              child: context.read<ProfileBloc>().state.hasMoreFriends
                  ? _buildHasMoreTweetsPart(context)
                  : Text(StringConstants().noMoreFriends),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHasMoreTweetsPart(BuildContext context) {
    return context.read<ProfileBloc>().state.getMoreFriendsStatus !=
            ProfileStatus.error
        ? _buildGetTweets(context)
        : _buildErrorWidget(context);
  }

  Widget _buildGetTweets(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return state.getMoreFriendsStatus == ProfileStatus.loading
            ? SizedBox(
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.30,
                child: const ShimmerPostAndMonumentResumeGrid(),
              )
            : ElevatedButton(
                onPressed: () {
                  _getNextFriends(context: context);
                },
                child: Text(StringConstants().showMoreResults),
              );
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Column(
      children: [
        Text(StringConstants().errorAppendedWhileGettingData),
        ElevatedButton(
          onPressed: () => _getNextFriends(context: context, isRefresh: true),
          child: Text(StringConstants().retry),
        ),
      ],
    );
  }

  void _getNextFriends({
    required BuildContext context,
    bool isRefresh = false,
  }) {
    final profileBloc = context.read<ProfileBloc>();

    if (profileBloc.state.status != ProfileStatus.loading) {
      profileBloc.add(
        GetFriendsEvent(isRefresh: isRefresh),
      );
    }
  }
}
