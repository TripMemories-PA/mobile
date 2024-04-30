import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/string_constants.dart';
import '../../num_extensions.dart';
import '../custom_card.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    this.title,
    this.subtitle,
  });

  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => Dialog(
        child: CustomCard(
          height: 200,
          content: Padding(
            padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(title ?? StringConstants().confirmAction),
                  16.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: Text(StringConstants().no),
                        onPressed: () => context.pop(false),
                      ),
                      ElevatedButton(
                        child: Text(StringConstants().yes),
                        onPressed: () => context.pop(true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      );
}

Future<bool> confirmationLogout(
  BuildContext context, {
  String? title,
  String? subtitle,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmationDialog(title: title, subtitle: subtitle),
    ) ??
    false;
