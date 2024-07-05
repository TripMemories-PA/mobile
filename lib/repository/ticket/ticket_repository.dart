import '../../object/ticket.dart';
import '../../service/ticket/tickets_remote_data_source.dart';
import 'i_tickets_repository.dart';

// TODO(nono): implement the monumentlocalDataSource
class TicketRepository implements ITicketRepository {
  TicketRepository({
    required this.ticketRemoteDataSource,
    //required this.profilelocalDataSource,
  });

  final TicketRemoteDataSource ticketRemoteDataSource;

  @override
  Future<List<Ticket>> getTickets(int? monumentId) {
    return ticketRemoteDataSource.getTickets(monumentId);
  }
}
