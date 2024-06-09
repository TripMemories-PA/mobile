import 'package:flutter/material.dart';

import '../component/profile_picture.dart';
import '../constants/my_colors.dart';
import '../num_extensions.dart';
import '../object/profile/profile.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.user});

  final Profile user;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              10.ph,
              ProfilePicture(
                uploadedFile: user.avatar,
              ),
              10.ph,
              Text(
                '${user.firstname} ${user.lastname}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '@${user.username}',
                style:
                    const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  color: MyColors.darkGrey,
                  height: 1,
                ),
              ),
              Expanded(
                child: Container(
                    color: Colors.red, child: Text('Chat content here')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
