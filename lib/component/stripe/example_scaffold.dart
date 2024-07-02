import 'package:flutter/material.dart';

import '../../num_extensions.dart';

class ExampleScaffold extends StatelessWidget {
  const ExampleScaffold({
    super.key,
    this.children = const [],
    this.tags = const [],
    this.title = '',
    this.padding,
  });
  final List<Widget> children;
  final List<String> tags;
  final String title;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            60.ph,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child:
                  Text(title, style: Theme.of(context).textTheme.headlineSmall),
            ),
            4.ph,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  for (final tag in tags) Chip(label: Text(tag)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (padding != null)
              Padding(
                padding: padding!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              )
            else
              ...children,
          ],
        ),
      ),
    );
  }
}
