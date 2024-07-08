import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/error/api_error.dart';
import '../../api/exception/custom_exception.dart';
import '../../api/qr_code_scanner/i_qr_code_scanner_service.dart';
import '../../api/qr_code_scanner/model/response/ticket_control.dart';

part 'qr_code_scannner_event.dart';
part 'qr_code_scannner_state.dart';

class QrCodeScannerBloc extends Bloc<QrCodeScannnerEvent, QrCodeScannerState> {
  QrCodeScannerBloc({required this.qrCodeScannerService})
      : super(QrCodeScannerState()) {
    on<CheckQrCodeEvent>((event, emit) async {
      emit(state.copyWith(qrCodeStatus: QrCodeStatus.loading));
      try {
        final TicketControl controlledTicket =
            await qrCodeScannerService.scanQrCode(event.qrCode);
        emit(
          state.copyWith(
            qrCodeStatus: controlledTicket.valid
                ? QrCodeStatus.valid
                : QrCodeStatus.invalid,
            ticketControl: controlledTicket,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            error: e is CustomException ? e.apiError : ApiError.unknown(),
            qrCodeStatus: QrCodeStatus.invalid,
          ),
        );
      }
    });
  }

  IQrCodeScannerService qrCodeScannerService;
}
