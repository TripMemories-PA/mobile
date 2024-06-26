import 'package:flutter/cupertino.dart';

import '../../num_extensions.dart';
import 'shimmer_friend_request.dart';

class ShimmerFriendRequestList extends StatelessWidget {
  const ShimmerFriendRequestList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ShimmerFriendRequest(),
        10.ph,
        const ShimmerFriendRequest(),
        10.ph,
        const ShimmerFriendRequest(),
        10.ph,
        const ShimmerFriendRequest(),
        10.ph,
        const ShimmerFriendRequest(),
        10.ph,
        const ShimmerFriendRequest(),
        10.ph,
        const ShimmerFriendRequest(),
        10.ph,
        const ShimmerFriendRequest(),
        10.ph,
        const ShimmerFriendRequest(),
      ],
    );
  }
}
