import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/profile/profile_bloc.dart';
import '../constants/my_colors.dart';
import '../constants/route_name.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/profile/profile.dart';
import 'custom_card.dart';

class MyFriendsComponent extends StatelessWidget {
  const MyFriendsComponent({
    super.key,
  });

  void _getFriends(BuildContext context) {
    context.read<ProfileBloc>().add(
          GetFriendsEvent(
            isRefresh: true,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomCard(
              width: MediaQuery.of(context).size.width * 0.40,
              height: 40,
              content: const Text(
                'Ajouter un amis',
                textAlign: TextAlign.center,
              ),
              borderColor: MyColors.purple,
            ),
            CustomCard(
              width: MediaQuery.of(context).size.width * 0.40,
              height: 40,
              content: const Text(
                'Gérer les demandes',
                textAlign: TextAlign.center,
              ),
              borderColor: MyColors.purple,
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
            ...context
                    .read<ProfileBloc>()
                    .state
                    .friends
                    ?.data
                    .map(
                      (friend) => Column(
                        children: [
                          _buildFriendCard(context, friend),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                    .toList() ??
                [],
            if (context.read<ProfileBloc>().state.status ==
                ProfileStatus.loading)
              Center(
                child: context.read<ProfileBloc>().state.hasMoreTweets
                    ? (context.read<ProfileBloc>().state.status !=
                            ProfileStatus.loading
                        ? const Text('SHIMMER HERe')
                        // TODO(nono): SHIMMER
                        : _buildErrorWidget(context))
                    : Text(StringConstants().noMoreFriends),
              ),
          ],
        );
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Column(
      children: [
        Text(StringConstants().errorAppendedWhileGettingData),
        ElevatedButton(
          onPressed: () => _getFriends(context),
          child: Text(StringConstants().retry),
        ),
      ],
    );
  }

  CustomCard _buildFriendCard(BuildContext context, Profile friend) {
    final String? avatarUrl = friend.avatar?.url;
    return CustomCard(
      width: MediaQuery.of(context).size.width * 0.90,
      height: 55,
      borderColor: MyColors.lightGrey,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 12,
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                  child: avatarUrl != null
                      ? CachedNetworkImage(
                          imageUrl: avatarUrl,
                          fit: BoxFit.cover,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                              value: downloadProgress.progress,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                      : const CircleAvatar(
                          backgroundColor: MyColors.lightGrey,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text(
                    '${friend.firstname} ' '${friend.lastname}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '@${friend.username}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              SizedBox(
                width: 30,
                height: 30,
                child: IconButton(
                  iconSize: 15,
                  icon: const Icon(Icons.chat),
                  color: Colors.white,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(MyColors.purple),
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: 30,
                height: 30,
                child: IconButton(
                  iconSize: 15,
                  icon: const Icon(Icons.remove_red_eye),
                  color: Colors.white,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(MyColors.purple),
                  ),
                  onPressed: () =>
                      context.push('${RouteName.profilePage}/${friend.id}'),
                ),
              ),
              const SizedBox(width: 30),
            ],
          ),
        ],
      ),
    );
  }
}
