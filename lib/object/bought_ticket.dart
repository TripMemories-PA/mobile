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

  factory BoughtTicket.fromJson(Map<String, dynamic> json) {
    return BoughtTicket(
      id: json['id'] as int,
      usedAt: json['usedAt'] == null
          ? null
          : DateTime.parse(json['usedAt'] as String),
      paid: json['paid'] as bool,
      qrCode: json['qrCode'] as String,
      ticketId: json['ticketId'] as int,
      userId: json['userId'] as int,
      ticket: Ticket.fromJson(json['ticket'] as Map<String, dynamic>),
      user: Profile.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  int id;
  DateTime? usedAt;
  bool paid;
  String qrCode;
  int ticketId;
  int userId;
  Ticket ticket;
  Profile user;
}
