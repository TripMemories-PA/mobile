import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trip_memories_mobile/component/custom_card.dart';

class ProfileBanner extends StatelessWidget {
  const ProfileBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          child: CircleAvatar(
            child: Image.asset('assets/images/profileSample.png'),
          ),
        ),
        Text(
          'Jane Doe',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(
          '@jane_doe',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
        CustomCard(
          width: 20,
          heigth: 10,
          content: Icon(
            Icons.logout,
          ),
        ),
        CustomCard(width: 40, heigth: 10, content: Text('Editer'))
      ],
    );
  }
}
