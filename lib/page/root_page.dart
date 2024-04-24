import 'package:flutter/material.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(padding: EdgeInsets.all(4)),
          ],
        ),
      ),
    );
  }
}
