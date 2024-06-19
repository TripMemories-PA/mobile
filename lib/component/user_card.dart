import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/user_searching_bloc/user_searching_bloc.dart';
import '../constants/my_colors.dart';
import '../constants/route_name.dart';
import '../object/profile/profile.dart';
import 'custom_card.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.user,
    this.needToPop = false,
  });

  final Profile user;
  final bool needToPop;

  @override
  Widget build(BuildContext context) {
    {
      final String? avatarUrl = user.avatar?.url;
      final bool isFriend = user.isFriend ?? false;
      return CustomCard(
        width: 165,
        height: 150,
        borderColor: MyColors.lightGrey,
        content: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUserPhoto(avatarUrl, context, user.id.toString()),
              Row(
                children: [
                  SizedBox(
                    width: 115,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.firstname} '
                          '${user.lastname}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@${user.username}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: MyColors.purple,
                      shape: BoxShape.circle,
                    ),
                    child: isFriend
                        ? _buildChatIconButton(context)
                        : _buildNotFriendButton(context, user),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  StatelessWidget _buildNotFriendButton(BuildContext context, Profile user) {
    final bool isReceivedFriendRequest = user.isReceivedFriendRequest ?? false;
    final bool isSentFriendRequest = user.isSentFriendRequest ?? false;
    if (isSentFriendRequest || isReceivedFriendRequest) {
      return _buildDisableButton(
        isReceivedFriendRequest: isReceivedFriendRequest,
        isSentFriendRequest: isSentFriendRequest,
      );
    } else {
      return _buildAddFriendIconButton(context);
    }
  }

  Container _buildDisableButton({
    required bool isReceivedFriendRequest,
    required bool isSentFriendRequest,
  }) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: MyColors.purple,
      ),
      child: Icon(
        isSentFriendRequest ? Icons.present_to_all : Icons.move_to_inbox,
        color: Colors.white,
        size: 15,
      ),
    );
  }

  IconButton _buildAddFriendIconButton(BuildContext context) {
    return IconButton(
      iconSize: 15,
      padding: EdgeInsets.zero,
      icon: Image.asset(
        'assets/images/addfriend.png',
        color: Colors.white,
      ),
      color: Colors.white,
      onPressed: () {
        context.read<UserSearchingBloc>().add(
              SendFriendRequestEvent(
                userId: user.id.toString(),
              ),
            );
      },
    );
  }

  IconButton _buildChatIconButton(BuildContext context) {
    return IconButton(
      iconSize: 15,
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.chat_outlined),
      color: Colors.white,
      onPressed: () {
        context.push('${RouteName.chatPage}/${user.id}', extra: user);
      },
    );
  }

  Stack _buildUserPhoto(
    String? avatarUrl,
    BuildContext context,
    String userId,
  ) {
    return Stack(
      children: [
        Container(
          width: 160,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: avatarUrl != null
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: CachedNetworkImage(
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
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: MyColors.lightGrey,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(),
              ),
            ),
            child: Theme(
              data: ThemeData(
                iconTheme: const IconThemeData(
                  color: MyColors.purple,
                ),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 10,
                icon: const Icon(Icons.remove_red_eye_outlined),
                color: Colors.black,
                onPressed: () {
                  context.push('${RouteName.profilePage}/$userId');
                  if (needToPop) {
                    context.pop();
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
