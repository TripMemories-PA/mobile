
import 'package:dio/dio.dart';

import '../../app.config.dart';
import '../../object/ticket.dart';
import '../../repository/ticket/i_tickets_repository.dart';
import '../dio.dart';
import '../error/api_error.dart';
import '../error/specific_error/auth_error.dart';
import '../exception/bad_request_exception.dart';
import '../exception/parsing_response_exception.dart';
import 'i_ticket_service.dart';
import 'model/query/post_ticket_query.dart';

class TicketService implements ITicketService, ITicketRepository {
  static const String apiPoiTickets = '${AppConfig.apiUrl}/pois/{ID}/tickets';
  static const String apiMyTickets = '${AppConfig.apiUrl}/me/tickets';
  static const String apiTickets = '${AppConfig.apiUrl}/tickets';
  static const String apiBuyTicket = '$apiMyTickets/buy';

  @override
  Future<List<Ticket>> getTickets(int? monumentId) async {
    Response response;
    try {
      response = await DioClient.instance.get(
        monumentId == null ? apiMyTickets : apiPoiTickets.replaceFirst('{ID}', monumentId.toString()),
      );
    } on BadRequestException {
      throw BadRequestException(AuthError.notAuthenticated());
    }
    try {
      final List<Ticket> tickets = [];
      for (final ticket in response.data) {
        tickets.add(Ticket.fromJson(ticket));
      }
      return tickets;
    } catch (e) {
      throw ParsingResponseException(
        ApiError.errorOccurredWhileParsingResponse(),
      );
    }
  }

  @override
  Future<void> postTicket({required PostTicketQuery ticket}) {
    // TODO: implement postTicket
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTicket({required int ticketId}) {
    // TODO: implement deleteTicket
    throw UnimplementedError();
  }

  @override
  Future<void> updateTicket({required Ticket ticket}) {
    // TODO: implement updateTicket
    throw UnimplementedError();
  }

}
