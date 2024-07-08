part of 'qr_code_scannner_bloc.dart';

enum QrCodeStatus {
  initial,
  loading,
  valid,
  invalid,
}

class QrCodeScannerState {
  QrCodeScannerState({
    this.qrCodeStatus = QrCodeStatus.initial,
    this.error,
    this.ticketControl,
  });

  final QrCodeStatus qrCodeStatus;
  final ApiError? error;
  final TicketControl? ticketControl;

  QrCodeScannerState copyWith({
    QrCodeStatus? qrCodeStatus,
    ApiError? error,
    TicketControl? ticketControl,
  }) {
    return QrCodeScannerState(
      qrCodeStatus: qrCodeStatus ?? this.qrCodeStatus,
      error: error ?? this.error,
      ticketControl: ticketControl ?? this.ticketControl,
    );
  }
}
