import '../../../../object/ticket_controll.dart';

class TicketControl {
  TicketControl({
    required this.valid,
    required this.ticket,
  });

  factory TicketControl.fromJson(Map<String, dynamic> json) {
    return TicketControl(
      valid: json['valid'],
      ticket: ControlledTicket.fromJson(json['ticket']),
    );
  }
  bool valid;
  ControlledTicket ticket;
}
