import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:vibration/vibration.dart';

import '../api/qr_code_scanner/qr_code_scanner_service.dart';
import '../bloc/qr_code_scanner/qr_code_scannner_bloc.dart';
import '../component/popup/confirmation_dialog.dart';
import '../component/qr_code_canner/scanner_button_widgets.dart';
import '../component/qr_code_canner/scanner_error_widget.dart';
import '../constants/my_colors.dart';
import '../constants/string_constants.dart';
import '../hooks/mobile_scanner_hook.dart';
import '../num_extensions.dart';
import '../utils/messenger.dart';

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: use `Offset.zero & size` instead of Rect.largest
    // we need to pass the size to the custom paint widget
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = MyColors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // First, draw the background,
    // with a cutout area that is a bit larger than the scan window.
    // Finally, draw the scan window itself.
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}
class ScanQrcodePage extends HookWidget {
  const ScanQrcodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileController = useMobileScannerController();
    final ticketInReview = useState(false);

    final scanWindow = Rect.fromCenter(
      center: MediaQuery.of(context).size.center(const Offset(0, -100)),
      width: 200,
      height: 200,
    );

    return BlocProvider(
      create: (context) =>
          QrCodeScannerBloc(qrCodeScannerService: QrCodeScannerService()),
      child: BlocBuilder<QrCodeScannerBloc, QrCodeScannerState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.black,
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
                          scanWindow: scanWindow,
                          controller: mobileController,
                          onDetect: (value) async {
                            final String? barcode =
                                value.barcodes.first.displayValue;
                            if (barcode == null) {
                              return;
                            }
                            mobileController.stop();
                            ticketInReview.value = true;
                            await confirmationPopUp(
                              context,
                              isOkPopUp: true,
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height * 0.5,
                              content: BlocProvider(
                                create: (context) => QrCodeScannerBloc(
                                  qrCodeScannerService: QrCodeScannerService(),
                                )..add(CheckQrCodeEvent(barcode)),
                                child: Column(
                                  children: [
                                    BlocListener<QrCodeScannerBloc,
                                        QrCodeScannerState>(
                                      listener: (context, state) async {
                                        if (state.qrCodeStatus ==
                                            QrCodeStatus.valid) {
                                          final player = AudioPlayer();
                                          await player.play(
                                            AssetSource(
                                              'sounds/rizz-sounds.mp3',
                                            ),
                                          );
                                          Vibration.vibrate(
                                            duration: 1000,
                                            amplitude: 128,
                                          );
                                        } else if (state.qrCodeStatus ==
                                            QrCodeStatus.invalid) {
                                          final player = AudioPlayer();
                                          await player.play(
                                            AssetSource(
                                              'sounds/windowError.mp3',
                                            ),
                                          );
                                          Vibration.vibrate(
                                            pattern: [0000, 500, 200, 500],
                                            amplitude: 255,
                                          );
                                        }
                                      },
                                      child: const SizedBox.shrink(),
                                    ),
                                    BlocBuilder<QrCodeScannerBloc,
                                        QrCodeScannerState>(
                                      builder: (context, state) {
                                        if (state.qrCodeStatus ==
                                            QrCodeStatus.loading) {
                                          return const Center(
                                            child: CupertinoActivityIndicator(),
                                          );
                                        }
                                        final bool isValidTicket =
                                            state.ticketControl?.valid ?? false;
                                        return Column(
                                          children: [
                                            if (isValidTicket)
                                              Lottie.asset(
                                                'assets/lottie/validation.json',
                                                width: 200,
                                                height: 200,
                                                fit: BoxFit.fill,
                                                repeat: false,
                                              )
                                            else
                                              Lottie.asset(
                                                'assets/lottie/error.json',
                                                width: 200,
                                                height: 200,
                                                fit: BoxFit.fill,
                                                repeat: false,
                                              ),
                                            20.ph,
                                            Text(
                                              isValidTicket
                                                  ? StringConstants()
                                                  .validTicket
                                                  : StringConstants()
                                                  .invalidTicket,
                                              style: const TextStyle(
                                                fontSize: 24,
                                              ),
                                            ),
                                            20.ph,
                                            Text(
                                              state.ticketControl?.ticket.ticket
                                                  .title ??
                                                  '',
                                              style: const TextStyle(
                                                fontSize: 24,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ).then((_) {
                              ticketInReview.value = false;
                              mobileController.start();
                            });
                          },
                          errorBuilder: (context, error, child) {
                            return ScannerErrorWidget(error: error);
                          },
                        ),
                      ),

                      ValueListenableBuilder(
                        valueListenable: mobileController,
                        builder: (context, value, child) {
                          if (!value.isInitialized ||
                              !value.isRunning ||
                              value.error != null) {
                            return const SizedBox();
                          }

                          return CustomPaint(
                            painter: ScannerOverlay(scanWindow: scanWindow),
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ToggleFlashlightButton(controller: mobileController),
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


class ScannedBarcodeLabel extends StatelessWidget {
  const ScannedBarcodeLabel({
    super.key,
    required this.barcodes,
  });

  final Stream<BarcodeCapture> barcodes;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: barcodes,
      builder: (context, snapshot) {
        final scannedBarcodes = snapshot.data?.barcodes ?? [];

        if (scannedBarcodes.isEmpty) {
          return const Text(
            'Scan something!',
            overflow: TextOverflow.fade,
            style: TextStyle(color: Colors.white),
          );
        }

        return Text(
          scannedBarcodes.first.displayValue ?? 'No display value.',
          overflow: TextOverflow.fade,
          style: const TextStyle(color: Colors.white),
        );
      },
    );
  }
}