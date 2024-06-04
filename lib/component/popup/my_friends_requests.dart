import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../api/auth/model/response/friend_request_response/friend_request_response.dart';
import '../../api/profile/profile_service.dart';
import '../../bloc/friend_request_bloc/friend_request_bloc.dart';
import '../../constants/my_colors.dart';
import '../../constants/route_name.dart';
import '../../constants/string_constants.dart';
import '../../num_extensions.dart';
import '../../repository/profile_repository.dart';
import '../../service/profile_remote_data_source.dart';
import '../../utils/messenger.dart';
import '../custom_card.dart';

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
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(MyColors.purple),
            ),
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
                        Messenger.showSnackBarQuickInfo(
                          state.status == FriendRequestStatus.accepted
                              ? StringConstants().friendRequestAccepted
                              : StringConstants().friendRequestRefused,
                          context,
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
      onTap: () {
        context.push(
          '${RouteName.profilePage}/${friendRequest.sender.id}',
        );
        context.pop();
      },
      width: MediaQuery.of(context).size.width * 0.90,
      height: 80,
      borderColor: MyColors.lightGrey,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 10,
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
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.fromBorderSide(
                    BorderSide(
                      color: MyColors.purple,
                    ),
                  ),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 15,
                  icon: const Icon(Icons.close),
                  color: MyColors.purple,
                  onPressed: () {
                    context.read<FriendRequestBloc>().add(
                          RejectFriendRequestEvent(
                            friendRequestId: friendRequest.id.toString(),
                          ),
                        );
                  },
                ),
              ),
              12.pw,
              Container(
                width: 1,
                height: 25,
                color: MyColors.lightGrey,
              ),
              12.pw,
              Container(
                width: 25,
                height: 25,
                decoration: const BoxDecoration(
                  color: MyColors.purple,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
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
              15.pw,
            ],
          ),
        ],
      ),
    );
  }

  SizedBox _buildUserPhoto(String? avatarUrl) {
    return SizedBox(
      width: 80,
      height: 65,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
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
