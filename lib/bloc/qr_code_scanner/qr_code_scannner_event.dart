part of 'qr_code_scannner_bloc.dart';

sealed class QrCodeScannnerEvent {}

class CheckQrCodeEvent extends QrCodeScannnerEvent {
  CheckQrCodeEvent(this.qrCode);

  final String qrCode;
}

class EndTicketReviewEvent extends QrCodeScannnerEvent {}

class StartTicketReviewEvent extends QrCodeScannnerEvent {}
