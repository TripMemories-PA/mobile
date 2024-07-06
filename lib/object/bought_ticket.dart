import 'profile.dart';
import 'ticket.dart';

class BoughtTicket {
  BoughtTicket({
    required this.id,
    this.usedAt,
    required this.paid,
    required this.qrCode,
    required this.ticketId,
    required this.userId,
    required this.ticket,
    required this.user,
  });

  int id;
  DateTime? usedAt;
  bool paid;
  String qrCode;
  int ticketId;
  int userId;
  Ticket ticket;
  Profile user;
}
