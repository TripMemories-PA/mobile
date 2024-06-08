import 'package:flutter/material.dart';

import '../object/profile/profile.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.user});

  final Profile user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Chat with ${user.firstname} ${user.lastname}'),
          const Expanded(
            child: Text('Chat content here'),
          ),
        ],
      ),
    );
  }
}
