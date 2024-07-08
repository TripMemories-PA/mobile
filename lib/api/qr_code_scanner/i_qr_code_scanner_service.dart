import 'model/response/ticket_control.dart';

abstract class IQrCodeScannerService {
  Future<TicketControl> scanQrCode(String qrCode);
}
