import 'package:flutter/material.dart';

import '../object/profile.dart';
import 'user_to_add_card.dart';

class FriendRequestsList extends StatelessWidget {
  const FriendRequestsList({
    super.key,
    required this.users,
    this.needToPop = false,
    this.padding = 0.0,
    this.verticalCellSpacing = 10.0,
    this.horizontalCellSpacing = 10.0,
  });

  final List<Profile> users;
  final bool needToPop;
  final double padding;

  final double verticalCellSpacing;
  final double horizontalCellSpacing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Center(
          child: Column(
            children: users
                .map(
                  (friend) => UserToAddCard(user: friend, needToPop: needToPop),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
