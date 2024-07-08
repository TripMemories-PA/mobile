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
    this.reviewingTicket = false,
    this.error,
    this.ticketControl,
  });

  final QrCodeStatus qrCodeStatus;
  final bool reviewingTicket;
  final ApiError? error;
  final TicketControl? ticketControl;

  QrCodeScannerState copyWith({
    QrCodeStatus? qrCodeStatus,
    bool? reviewingTicket,
    ApiError? error,
    TicketControl? ticketControl,
  }) {
    return QrCodeScannerState(
      qrCodeStatus: qrCodeStatus ?? this.qrCodeStatus,
      reviewingTicket: reviewingTicket ?? this.reviewingTicket,
      error: error ?? this.error,
      ticketControl: ticketControl ?? this.ticketControl,
    );
  }
}
