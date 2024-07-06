import 'dart:developer';

import 'package:flutter/material.dart';

import '../../constants/string_constants.dart';
import '../../utils/messenger.dart';

class LoadingButton extends StatefulWidget {
  const LoadingButton({super.key, required this.onPressed, required this.text});

  final Future Function()? onPressed;
  final String text;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed:
                (_isLoading || widget.onPressed == null) ? null : _loadFuture,
            child: _isLoading
                ? SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                : Text(widget.text),
          ),
        ),
      ],
    );
  }

  Future<void> _loadFuture() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onPressed!();
    } catch (e, s) {
      Messenger.showSnackBarError(StringConstants().errorOccurred);
      log(e.toString(), error: e, stackTrace: s);
      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
