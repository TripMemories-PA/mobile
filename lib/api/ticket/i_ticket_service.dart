import '../../object/ticket.dart';
import 'model/query/post_ticket_query.dart';

abstract class ITicketService {
  Future<void> postTicket({
    required PostTicketQuery ticket,
  });

  Future<void> deleteTicket({
    required int ticketId,
  });

  Future<void> updateTicket({
    required Ticket ticket,
  });

}
