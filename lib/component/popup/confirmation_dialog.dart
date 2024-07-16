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
    this.isOkPopUp = false,
    this.content,
    this.height,
    this.width,
  });

  final String? title;
  final String? subtitle;
  final bool? isOkPopUp;
  final Widget? content;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final Widget? tmpContent = content;
    return Dialog(
      child: CustomCard(
        borderColor: Colors.transparent,
        height: height ?? 200,
        width: width,
        content: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (tmpContent != null)
                tmpContent
              else
                Text(title ?? StringConstants().confirmAction),
              16.ph,
              if (isOkPopUp ?? false)
                Center(
                  child: TextButton(
                    child: Text(StringConstants().ok),
                    onPressed: () => context.pop(),
                  ),
                )
              else
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
}

Future<bool> confirmationPopUp(
  BuildContext context, {
  String? title,
  String? subtitle,
  bool? isOkPopUp,
  Widget? content,
  double? height,
  double? width,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmationDialog(
        title: title,
        subtitle: subtitle,
        isOkPopUp: isOkPopUp,
        content: content,
        height: height,
        width: width,
      ),
    ) ??
    false;
