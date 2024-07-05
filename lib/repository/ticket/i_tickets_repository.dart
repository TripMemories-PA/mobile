import '../../object/ticket.dart';

abstract class ITicketRepository {
  Future<List<Ticket>> getTickets(int? monumentId);
}
