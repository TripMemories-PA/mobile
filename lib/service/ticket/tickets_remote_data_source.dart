import '../../api/ticket/ticket_service.dart';
import '../../object/bought_ticket.dart';
import '../../object/ticket.dart';
import '../../repository/ticket/i_tickets_repository.dart';

class TicketRemoteDataSource implements ITicketRepository {
  final TicketService _ticketService = TicketService();

  @override
  Future<List<Ticket>> getTickets(int? monumentId) async {
    final List<Ticket> tickets = await _ticketService.getTickets(monumentId);
    return tickets;
  }

  @override
  Future<List<BoughtTicket>> getMyTickets() async {
    final List<BoughtTicket> tickets = await _ticketService.getMyTickets();
    return tickets;
  }
}
