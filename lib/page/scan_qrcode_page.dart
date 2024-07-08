
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../api/qr_code_scanner/qr_code_scanner_service.dart';
import '../bloc/qr_code_scanner/qr_code_scannner_bloc.dart';
import '../component/popup/confirmation_dialog.dart';
import '../component/qr_code_canner/scanner_button_widgets.dart';
import '../component/qr_code_canner/scanner_error_widget.dart';
import '../constants/string_constants.dart';
import '../utils/messenger.dart';
class _MobileScannerControllerHook extends Hook<MobileScannerController> {
  const _MobileScannerControllerHook();

  @override
  _MobileScannerControllerHookState createState() =>
      _MobileScannerControllerHookState();
}

class _MobileScannerControllerHookState
    extends HookState<MobileScannerController, _MobileScannerControllerHook> {
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
    use(const _MobileScannerControllerHook());

class ScannerOverlay extends CustomPainter {
  ScannerOverlay({
    required this.scanWindow,
    this.borderColor = Colors.green,
    this.borderWidth = 4.0,
  });

  final RRect scanWindow;
  final Color borderColor;
  final double borderWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.5);

    // Draw the grayed-out background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    // Clear the scan window area
    paint.blendMode = BlendMode.clear;
    canvas.drawRRect(scanWindow, paint);

    // Draw the border
    paint
      ..blendMode = BlendMode.srcOver
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawRRect(scanWindow, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ScanQrcodePage extends HookWidget {
  const ScanQrcodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileController = useMobileScannerController();
    final ticketInReview = useState(false);

    useEffect(
      () {
        Future<void> createScrollListener() async {
          if (!await mobileController.barcodes.isEmpty) {
            if (!ticketInReview.value) {
              ticketInReview.value = true;
              if(!context.mounted) {
                return;
              }
              await confirmationPopUp(
                context,
                isOkPopUp: true,
                content: BlocProvider(
                  create: (context) => QrCodeScannerBloc(
                    qrCodeScannerService: QrCodeScannerService(),
                  )..add(CheckQrCodeEvent(mobileController.value.toString())),
                  child: BlocBuilder<QrCodeScannerBloc, QrCodeScannerState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          Text(
                            state.ticketControl?.valid.toString() ?? 'pas de donnée',
                          ),
                          Text(
                            state.ticketControl?.ticket.title ?? 'pas de donnée',
                          ),
                        ],

                      );
                    },
                  ),
                ),
              ).then((_) => ticketInReview.value = false);
            }
          }
        }

        mobileController.addListener(createScrollListener);
        return () => mobileController.removeListener(createScrollListener);
      },
      const [],
    );

    final scanWindow = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: MediaQuery.of(context).size.center(const Offset(0, -100)),
        width: 300,
        height: 300,
      ),
      const Radius.circular(20),
    );

    return BlocProvider(
      create: (context) =>
          QrCodeScannerBloc(qrCodeScannerService: QrCodeScannerService()),
      child: BlocBuilder<QrCodeScannerBloc, QrCodeScannerState>(
        builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                BlocListener<QrCodeScannerBloc, QrCodeScannerState>(
                  listener: (context, state) {
                    if (state.error != null) {
                      Messenger.showSnackBarError(
                        state.error!.getDescription(),
                      );
                    }
                  },
                  child: const SizedBox.shrink(),
                ),
                Container(
                  height: 50,
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text(
                      StringConstants().qrCodeScannerTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Center(
                        child: MobileScanner(
                          controller: mobileController,
                          scanWindow: scanWindow.outerRect,
                          errorBuilder: (context, error, child) {
                            return ScannerErrorWidget(error: error);
                          },
                        ),
                      ),
                      CustomPaint(
                        painter: ScannerOverlay(
                          scanWindow: scanWindow,
                          borderColor: Theme.of(context).colorScheme.primary,
                        ),
                        child: Container(),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ToggleFlashlightButton(
                                  controller: mobileController),
                              SwitchCameraButton(controller: mobileController),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
