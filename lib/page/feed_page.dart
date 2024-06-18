import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/route_name.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteName.editTweetPage),
        child: const Icon(Icons.add),
      ),
      body: const ColoredBox(
        color: Colors.yellow,
        child: Center(
          child: Text('FEED'),
        ),
      ),
    );
  }
}
