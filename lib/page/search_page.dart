import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: Colors.blue,
        child: Center(
          child: InkWell(
              onTap: () => print(ModalRoute.of(context)?.settings.name),
              child: Text('RECHERCHER')),
        ),
      ),
    );
  }
}
