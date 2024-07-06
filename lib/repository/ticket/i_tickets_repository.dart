import '../../object/bought_ticket.dart';
import '../../object/ticket.dart';

abstract class ITicketRepository {
  Future<List<Ticket>> getTickets(int? monumentId);

  Future<List<BoughtTicket>> getMyTickets();
}
