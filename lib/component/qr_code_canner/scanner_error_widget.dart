import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../constants/string_constants.dart';

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    if (error.errorCode == MobileScannerErrorCode.controllerUninitialized) {
      errorMessage = StringConstants().controllerNotReady;
    } else if (error.errorCode == MobileScannerErrorCode.permissionDenied) {
      errorMessage = StringConstants().permissionDenied;
    } else if (error.errorCode == MobileScannerErrorCode.unsupported) {
      errorMessage = StringConstants().unsupportedDevice;
    } else {
      errorMessage = StringConstants().errorOccurred;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
