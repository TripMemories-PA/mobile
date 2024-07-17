import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:progressive_image/progressive_image.dart';

import '../bloc/user_searching_bloc/user_searching_bloc.dart';
import '../constants/my_colors.dart';
import '../constants/route_name.dart';
import '../dto/conversation/conversation_dto.dart';
import '../dto/conversation/private_conversation_dto.dart';
import '../num_extensions.dart';
import '../object/profile.dart';
import 'custom_card.dart';

class UserToAddCard extends StatelessWidget {
  const UserToAddCard({
    super.key,
    required this.user,
    this.needToPop = false,
  });

  final Profile user;
  final bool needToPop;

  @override
  Widget build(BuildContext context) {
    {
      final bool isFriend = user.isFriend ?? false;
      final String? avatarUrl = user.avatar?.url;
      return CustomCard(
        onTap: () {
          context.push(
            '${RouteName.profilePage}/${user.id}',
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
                10.pw,
                _buildUserPhoto(avatarUrl, context),
                10.pw,
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    children: [
                      Text(
                        '${user.firstname} '
                        '${user.lastname}',
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
                const Spacer(),
                if (isFriend)
                  _buildChatIconButton(context, user)
                else
                  _buildAddFriendIconButton(context),
                const Spacer(),
              ],
            ),
          ],
        ),
      );
    }
  }

  SizedBox _buildAddFriendIconButton(BuildContext context) {
    final bool hasSentFriendRequest = user.hasSentFriendRequest ?? false;
    final bool hasReceivedFriendRequest =
        user.hasReceivedFriendRequest ?? false;

    final bool isDisabled = hasReceivedFriendRequest || hasSentFriendRequest;

    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        style: isDisabled
            ? ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.tertiary,
                ),
              )
            : null,
        iconSize: 15,
        padding: EdgeInsets.zero,
        icon: Image.asset(
          'assets/images/addfriend.png',
          color: isDisabled
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.surface,
        ),
        color: Colors.white,
        onPressed: () {
          context.read<UserSearchingBloc>().add(
                SendFriendRequestEvent(
                  userId: user.id.toString(),
                ),
              );
        },
      ),
    );
  }

  Widget _buildChatIconButton(BuildContext context, Profile user) {
    final String? channel = user.channel;
    if (channel == null) {
      return const SizedBox.shrink();
    }
    final ConversationDto conversationDto = PrivateConversationDto(
      id: user.id,
      channel: channel,
      user: user,
    );
    return IconButton(
      iconSize: 15,
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.chat_outlined),
      color: Colors.white,
      onPressed: () {
        context.pop();
        context.push(
          '${RouteName.chatPage}/${user.id}',
          extra: conversationDto,
        );
      },
    );
  }

  SizedBox _buildUserPhoto(String? avatarUrl, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.15,
      height: 65,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
        child: avatarUrl != null
            ? LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return ProgressiveImage(
                    placeholder: null,
                    // size: 1.87KB
                    thumbnail: const AssetImage(
                      'assets/images/user_placeholder.jpg',
                    ),
                    // size: 1.29MB
                    image: NetworkImage(avatarUrl),
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    fit: BoxFit.cover,
                  );
                },
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
}
