import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
import '../constants/string_constants.dart';
import '../hooks/mobile_scanner_hook.dart';
import '../num_extensions.dart';
import '../utils/messenger.dart';

class ScannerOverlayAndroid extends CustomPainter {
  ScannerOverlayAndroid({
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

class ScanQrcodePageAndroid extends HookWidget {
  const ScanQrcodePageAndroid({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileController = useMobileScannerController();
    final ticketInReview = useState(false);

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
                  child: const Center(
                    child: Text(
                      StringConstants.qrCodeScannerTitle,
                      style: TextStyle(
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
                              height: MediaQuery.of(context).size.height * 0.55,
                              content: BlocProvider(
                                create: (context) => QrCodeScannerBloc(
                                  qrCodeScannerService: QrCodeScannerService(),
                                )..add(CheckQrCodeEvent(barcode)),
                                child: BlocConsumer<QrCodeScannerBloc,
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
                                  builder: (context, state) {
                                    if (state.qrCodeStatus ==
                                        QrCodeStatus.loading) {
                                      return const Center(
                                        child: CupertinoActivityIndicator(),
                                      );
                                    }
                                    final bool isValidTicket =
                                        state.ticketControl?.valid ?? false;
                                    final int? groupSize;
                                    if (state.ticketControl?.ticket.meetId !=
                                        null) {
                                      groupSize = 1;
                                    } else {
                                      groupSize = state.ticketControl?.ticket
                                          .ticket.groupSize;
                                    }
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
                                              ? StringConstants.validTicket
                                              : StringConstants.invalidTicket,
                                          style: const TextStyle(
                                            fontSize: 24,
                                          ),
                                        ),
                                        20.ph,
                                        AutoSizeText(
                                          maxLines: 1,
                                          state.ticketControl?.ticket.ticket
                                                  .title ??
                                              '',
                                          style: const TextStyle(
                                            fontSize: 24,
                                          ),
                                          minFontSize: 10,
                                        ),
                                        10.ph,
                                        if (groupSize != null)
                                          AutoSizeText(
                                            '${StringConstants.nbPersons}: $groupSize',
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                            minFontSize: 10,
                                            maxLines: 1,
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ).then((_) {
                              ticketInReview.value = false;
                              mobileController.start();
                            });
                          },
                        ),
                      ),
                      CustomPaint(
                        painter: ScannerOverlayAndroid(
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
                                controller: mobileController,
                              ),
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
