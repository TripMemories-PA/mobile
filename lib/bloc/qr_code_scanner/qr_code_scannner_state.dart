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
  });

  final QrCodeStatus qrCodeStatus;

  QrCodeScannerState copyWith({
    QrCodeStatus? qrCodeStatus,
  }) {
    return QrCodeScannerState(
      qrCodeStatus: qrCodeStatus ?? this.qrCodeStatus,
    );
  }
}
