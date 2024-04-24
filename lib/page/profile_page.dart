import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The details screen for either the A or B screen.
class ProfilePage extends StatefulWidget {
  /// Constructs a [ProfilePage].
  const ProfilePage({
    this.param,
    this.extra,
    this.withScaffold = true,
    super.key,
  });

  /// The label to display in the center of the screen.

  /// Optional param
  final String? param;

  /// Optional extra object
  final Object? extra;

  /// Wrap in scaffold
  final bool withScaffold;

  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

/// The state for DetailsScreen
class ProfilePageState extends State<ProfilePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _build(context),
    );
  }

  Widget _build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Details', style: Theme.of(context).textTheme.titleLarge),
          const Padding(padding: EdgeInsets.all(4)),
          TextButton(
            onPressed: () {
              setState(() {
                _counter++;
              });
            },
            child: const Text('Increment counter'),
          ),
          const Padding(padding: EdgeInsets.all(8)),
          if (widget.param != null)
            Text('Parameter: ${widget.param!}',
                style: Theme.of(context).textTheme.titleMedium),
          const Padding(padding: EdgeInsets.all(8)),
          if (widget.extra != null)
            Text('Extra: ${widget.extra!}',
                style: Theme.of(context).textTheme.titleMedium),
          if (!widget.withScaffold) ...<Widget>[
            const Padding(padding: EdgeInsets.all(16)),
            TextButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              child: const Text('< Back',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ]
        ],
      ),
    );
  }
}
