import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/profile/profile_bloc.dart';
import '../constants/my_colors.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/profile/profile.dart';
import 'custom_card.dart';
import 'popup/my_friends_requests.dart';
import 'popup/user_searching.dart';
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
              height: 40,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add,
                    color: MyColors.purple,
                  ),
                  10.pw,
                  const Text(
                    'Ajouter un amis',
                    textAlign: TextAlign.center,
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
              height: 40,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.groups,
                    color: MyColors.purple,
                  ),
                  10.pw,
                  const Text(
                    'Gérer les demandes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
              return const CircularProgressIndicator();
            } else {
              return _buildFriendsList(context);
            }
          },
        ),
      ],
    );
  }

  Widget _buildFriendsList(BuildContext context) {
    final List<Profile>? friends =
        context.read<ProfileBloc>().state.friends?.data;
    if (friends == null || friends.isEmpty) {
      return const Center(child: Text('Aucun amis ajouté'));
    }
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Column(
          children: [
            UserList(
              users: state.friends!.data,
            ),
            Center(
              child: context.read<ProfileBloc>().state.hasMoreTweets
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
        // TODO(nono): SHIMMER
        : _buildErrorWidget(context);
  }

  Widget _buildGetTweets(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return state.getMoreFriendsStatus == ProfileStatus.loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {
                  _getNextFriends(context: context);
                },
                child: const Text('Voir plus de résultats'),
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
