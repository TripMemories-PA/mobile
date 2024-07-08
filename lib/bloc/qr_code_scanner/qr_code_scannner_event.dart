part of 'qr_code_scannner_bloc.dart';

sealed class QrCodeScannnerEvent {}

class CheckQrCodeEvent extends QrCodeScannnerEvent {
  CheckQrCodeEvent(this.qrCode);

  final String qrCode;
}
