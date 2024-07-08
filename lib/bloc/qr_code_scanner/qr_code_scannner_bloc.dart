import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/qr_code_scanner/i_qr_code_scanner_service.dart';

part 'qr_code_scannner_event.dart';

part 'qr_code_scannner_state.dart';

class QrCodeScannerBloc extends Bloc<QrCodeScannnerEvent, QrCodeScannerState> {
  QrCodeScannerBloc({required this.qrCodeScannerService})
      : super(QrCodeScannerState()) {
    on<CheckQrCodeEvent>((event, emit) async {
      emit(state.copyWith(qrCodeStatus: QrCodeStatus.loading));
      final bool isValid = await qrCodeScannerService.scanQrCode(event.qrCode);
      emit(
        state.copyWith(
          qrCodeStatus: isValid ? QrCodeStatus.valid : QrCodeStatus.invalid,
        ),
      );
    });
  }

  IQrCodeScannerService qrCodeScannerService;
}
