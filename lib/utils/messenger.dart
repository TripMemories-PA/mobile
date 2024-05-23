import 'package:flutter/material.dart';

class Messenger {
  static late GlobalKey<ScaffoldMessengerState> _messengerKey;

  static GlobalKey<ScaffoldMessengerState> setMessengerKey(
    final GlobalKey<ScaffoldMessengerState> key,
  ) =>
      _messengerKey = key;

  static void showSnackBarError(final String content) {
    assert(
      _messengerKey.currentState != null,
      'Navigator key must be initialized.',
    );

    _messengerKey.currentState!.showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.warning_rounded, color: Colors.white),
            ),
            Text(content, style: const TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  static void showSnackBarSuccess(final String content) {
    assert(_messengerKey.currentState != null,
        'Navigator key must be initialized.');

    _messengerKey.currentState!.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.check_circle_rounded, color: Colors.white),
            ),
            Text(content, style: const TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  static void showSnackBarQuickInfo(
    final String content,
    final BuildContext context,
  ) {
    assert(
      _messengerKey.currentState != null,
      'Navigator key must be initialized.',
    );

    _messengerKey.currentState!.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Icon(Icons.check_circle_rounded, color: Colors.white),
            ),
            Expanded(
              child: Text(
                content,
                style: const TextStyle(color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
