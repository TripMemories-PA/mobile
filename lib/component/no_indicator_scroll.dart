import 'package:flutter/cupertino.dart';

class _NoOverscrollBehaviour extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      final BuildContext context,
      final Widget child,
      final ScrollableDetails details,
      ) {
    return child;
  }
}

class NoIndicatorScroll extends StatelessWidget {
  const NoIndicatorScroll({required this.child, super.key});

  final Widget child;

  @override
  Widget build(final BuildContext context) {
    return ScrollConfiguration(
      behavior: _NoOverscrollBehaviour(),
      child: child,
    );
  }
}
