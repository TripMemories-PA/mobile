
import '../../../../object/ticket.dart';

class TicketControl {
  
  TicketControl({
    required this.valid,
    required this.ticket,
  });
  
  factory TicketControl.fromJson(Map<String, dynamic> json) {
    return TicketControl(
      valid: json['valid'],
      ticket: Ticket.fromJson(json['ticket']),
    );
  }
  bool valid;
  Ticket ticket;
}
