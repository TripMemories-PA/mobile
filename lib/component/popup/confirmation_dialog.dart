import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/string_constants.dart';
import '../../num_extensions.dart';
import '../custom_card.dart';

enum PopupType {ok, yesNo}

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    this.title,
    this.subtitle,
    this.popupType = PopupType.yesNo,
    this.content,
    this.height,
    this.width,
  });

  final String? title;
  final String? subtitle;
  final PopupType popupType;
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
                Text(title ?? StringConstants.confirmAction),
              16.ph,
              if (popupType == PopupType.ok)
                Center(
                  child: TextButton(
                    child: const Text(StringConstants.ok),
                    onPressed: () => context.pop(),
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text(StringConstants.no),
                      onPressed: () => context.pop(false),
                    ),
                    ElevatedButton(
                      child: const Text(StringConstants.yes),
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
        popupType: (isOkPopUp ?? false) ? PopupType.ok : PopupType.yesNo,
        content: content,
        height: height,
        width: width,
      ),
    ) ??
    false;
