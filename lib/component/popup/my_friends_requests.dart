import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../api/auth/model/response/friend_request_response/friend_request_response.dart';
import '../../api/profile/profile_service.dart';
import '../../bloc/friend_request_bloc/friend_request_bloc.dart';
import '../../bloc/notifier_bloc/notification_type.dart';
import '../../bloc/notifier_bloc/notifier_bloc.dart';
import '../../bloc/notifier_bloc/notifier_event.dart';
import '../../constants/my_colors.dart';
import '../../constants/route_name.dart';
import '../../constants/string_constants.dart';
import '../../num_extensions.dart';
import '../../repository/profile_repository.dart';
import '../../service/profile_remote_data_source.dart';
import '../custom_card.dart';
import '../notifier_widget.dart';

class MyFriendsRequests extends StatelessWidget {
  const MyFriendsRequests({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Builder(
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            child: CustomCard(
              width: MediaQuery.of(context).size.width * 0.90,
              height: MediaQuery.of(context).size.height * 0.81,
              content: _buildContent(context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      children: [
        _buildTitle(context),
        _buildFriendsList(context),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'My Friends Requests',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFriendsList(BuildContext context) {
    return RepositoryProvider<ProfileRepository>(
      create: (context) => ProfileRepository(
        profileRemoteDataSource: ProfileRemoteDataSource(),
        // TODO(nono): Implement ProfileLocalDataSource
        //profilelocalDataSource: ProfileLocalDataSource(),
      ),
      child: BlocProvider(
        create: (context) => FriendRequestBloc(
          profileRepository: RepositoryProvider.of<ProfileRepository>(context),
          profileService: ProfileService(),
        )..add(GetFriendRequestEvent(isRefresh: true)),
        child: BlocBuilder<FriendRequestBloc, FriendRequestState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  ...context
                          .read<FriendRequestBloc>()
                          .state
                          .friendRequests
                          ?.data
                          .map(
                            (friend) => Column(
                              key: ObjectKey(friend),
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
                  Center(
                    child: context.read<FriendRequestBloc>().state.hasMoreTweets
                        ? (context.read<FriendRequestBloc>().state.status !=
                                FriendRequestStatus.error
                            ? const Text('SHIMMER HERe')
                            // TODO(nono): SHIMMER
                            : _buildErrorWidget(context))
                        : Text(StringConstants().noMoreFriends),
                  ),
                  BlocListener<FriendRequestBloc, FriendRequestState>(
                    listener: (context, state) {
                      if (state.status == FriendRequestStatus.accepted ||
                          state.status == FriendRequestStatus.refused) {
                        context.read<NotifierBloc>().add(
                              AppendNotification(
                                notification: state.status ==
                                        FriendRequestStatus.accepted
                                    ? StringConstants().friendRequestAccepted
                                    : StringConstants().friendRequestRefused,
                                type: NotificationType.info,
                              ),
                            );
                      }
                    },
                    child: const SizedBox.shrink(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  CustomCard _buildFriendCard(
    BuildContext context,
    FriendRequest friendRequest,
  ) {
    final String? avatarUrl = friendRequest.sender.avatar?.url;
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
              _buildUserPhoto(avatarUrl),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text(
                    '${friendRequest.sender.firstname} '
                    '${friendRequest.sender.lastname}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '@${friendRequest.sender.username}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              Container(
                width: 33,
                height: 33,
                decoration: const BoxDecoration(
                  color: MyColors.success,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  iconSize: 15,
                  icon: const Icon(Icons.check),
                  color: Colors.white,
                  onPressed: () {
                    context.read<FriendRequestBloc>().add(
                          AcceptFriendRequestEvent(
                            friendRequestId: friendRequest.id.toString(),
                          ),
                        );
                  },
                ),
              ),
              10.pw,
              Container(
                width: 33,
                height: 33,
                decoration: const BoxDecoration(
                  color: MyColors.fail,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  iconSize: 15,
                  icon: const Icon(Icons.close),
                  color: Colors.white,
                  onPressed: () {
                    context.read<FriendRequestBloc>().add(
                          RejectFriendRequestEvent(
                            friendRequestId: friendRequest.id.toString(),
                          ),
                        );
                  },
                ),
              ),
              10.pw,
              Container(
                width: 33,
                height: 33,
                decoration: const BoxDecoration(
                  color: MyColors.purple,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  iconSize: 15,
                  icon: const Icon(Icons.remove_red_eye),
                  color: Colors.white,
                  onPressed: () => context
                      .push('${RouteName.profilePage}/${friendRequest.id}'),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }

  SizedBox _buildUserPhoto(String? avatarUrl) {
    return SizedBox(
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
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                  child: CircularProgressIndicator(
                    value: downloadProgress.progress,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )
            : const CircleAvatar(
                backgroundColor: MyColors.lightGrey,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Column(
      children: [
        Text(StringConstants().errorAppendedWhileGettingData),
        ElevatedButton(
          onPressed: () => _getFriendRequests(context),
          child: Text(StringConstants().retry),
        ),
      ],
    );
  }

  void _getFriendRequests(BuildContext context) {
    context.read<FriendRequestBloc>().add(
          GetFriendRequestEvent(isRefresh: false),
        );
  }
}

Future<bool> myFriendsRequestsPopup(
  BuildContext context,
) async {
  return await showDialog<bool>(
        context: context,
        builder: (_) => const MyFriendsRequests(),
      ) ??
      false;
}
