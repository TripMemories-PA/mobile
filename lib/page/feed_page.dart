import 'package:flutter/material.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: ColoredBox(
      color: Colors.yellow,
      child: Center(
        child: Text('FEED'),
      ),
    ));
  }
}
