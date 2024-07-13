import 'package:dio/dio.dart';

import '../../app.config.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../error/specific_error/auth_error.dart';
import '../exception/bad_request_exception.dart';
import '../exception/parsing_response_exception.dart';
import 'i_buy_ticket_service.dart';
import 'model/query/buy_ticket_query.dart';
import 'model/response/buy_ticket_response.dart';

class BuyTicketService implements IBuyTicketService {
  static const String apiBuyTicket = '${AppConfig.apiUrl}/me/tickets/buy';
  static const String apiBuyTicketForMeet =
      '${AppConfig.apiUrl}/meets/{MEET_ID}/pay';

  @override
  Future<BuyTicketResponse> buyTicket({
    required BuyTicketQuery tickets,
  }) async {
    Response response;
    try {
      final body = tickets.toJson();
      response = await DioClient.instance.post(
        apiBuyTicket,
        data: body,
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return BuyTicketResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<BuyTicketResponse> buyTicketForMeet(int meetId) async {
    Response response;
    try {
      response = await DioClient.instance.post(
        apiBuyTicketForMeet.replaceAll('{MEET_ID}', meetId.toString()),
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      return BuyTicketResponse.fromJson(response.data);
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }
}
