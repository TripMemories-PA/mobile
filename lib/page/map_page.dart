import 'package:flutter/material.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ColoredBox(
        color: Colors.red,
        child: Center(
          child: Text('MAP PAGE'),
        ),
      ),
    );
  }
}
