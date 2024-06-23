import 'package:flutter/material.dart';

import '../object/profile/profile.dart';
import 'user_card.dart';

class UserList extends StatelessWidget {
  const UserList({super.key, required this.users, this.needToPop = false});

  final List<Profile> users;
  final bool needToPop;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: users
          .map(
            (friend) => UserCard(user: friend, needToPop: needToPop),
          )
          .toList(),
    );
  }
}
