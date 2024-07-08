import 'package:dio/dio.dart';

import '../../app.config.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../error/specific_error/auth_error.dart';
import '../exception/bad_request_exception.dart';
import '../exception/parsing_response_exception.dart';
import 'i_qr_code_scanner_service.dart';

class QrCodeScannerService implements IQrCodeScannerService {
  static const String checkQrCodeUrl = '${AppConfig.apiUrl}/tickets/validate';

  @override
  Future<bool> scanQrCode(String qrCode) async {
    Response response;
    try {
      response = await DioClient.instance.post(
        checkQrCodeUrl,
        data: {
          'qrCode': qrCode,
        },
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return response.data['valid'] as bool;
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }
}
