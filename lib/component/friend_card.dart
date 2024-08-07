import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:progressive_image/progressive_image.dart';

import '../constants/my_colors.dart';
import '../constants/route_name.dart';
import '../num_extensions.dart';
import '../object/profile.dart';
import 'custom_card.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({super.key, required this.friend});

  final Profile friend;

  @override
  Widget build(BuildContext context) {
    final String? avatarUrl = friend.avatar?.url;
    return CustomCard(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 100,
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
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: MyColors.purple,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  iconSize: 15,
                  icon: const Icon(Icons.chat),
                  color: Colors.white,
                  onPressed: () {},
                ),
              ),
              15.pw,
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: MyColors.purple,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  iconSize: 15,
                  icon: const Icon(Icons.remove_red_eye),
                  color: Colors.white,
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

  SizedBox _buildUserPhoto(String? avatarUrl) {
    return SizedBox(
      width: 40,
      height: 40,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(50.0),
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
                  size: 50,
                  color: Colors.grey,
                ),
              ),
      ),
    );
  }
}
