import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MobileScannerControllerHook extends Hook<MobileScannerController> {
  const MobileScannerControllerHook();

  @override
  MobileScannerControllerHookState createState() =>
      MobileScannerControllerHookState();
}

class MobileScannerControllerHookState
    extends HookState<MobileScannerController, MobileScannerControllerHook> {
  late MobileScannerController _controller;

  @override
  void initHook() {
    super.initHook();
    _controller = MobileScannerController(
      formats: const [BarcodeFormat.qrCode],
    );
  }

  @override
  MobileScannerController build(BuildContext context) => _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

MobileScannerController useMobileScannerController() =>
    use(const MobileScannerControllerHook());
