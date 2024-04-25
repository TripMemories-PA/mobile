import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ColoredBox(
        color: Colors.green,
        child: Center(
          child: Text('PROFILE PAGE'),
        ),
      ),
    );
  }
}
