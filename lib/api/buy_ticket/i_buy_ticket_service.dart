import 'model/query/buy_ticket_query.dart';
import 'model/response/buy_ticket_response.dart';

abstract class IBuyTicketService {
  Future<BuyTicketResponse> buyTicket({
    required BuyTicketQuery tickets,
  });
}
