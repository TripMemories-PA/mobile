import 'package:flutter/material.dart';

import '../object/profile/profile.dart';
import 'user_card.dart';

class UserList extends StatelessWidget {
  const UserList({
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
          child: Wrap(
            spacing: horizontalCellSpacing,
            runSpacing: verticalCellSpacing,
            children: users
                .map(
                  (friend) => UserCard(user: friend, needToPop: needToPop),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
