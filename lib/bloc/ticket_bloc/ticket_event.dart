part of 'ticket_bloc.dart';

sealed class TicketEvent {}

class GetTicketsEvent extends TicketEvent {
  GetTicketsEvent({
    this.monumentId,
  });

  final int? monumentId;
}

class PostTicketEvent extends TicketEvent {
  PostTicketEvent({
    required this.ticket,
  });

  final PostTicketQuery ticket;
}

class DeleteTicketEvent extends TicketEvent {
  DeleteTicketEvent({
    required this.ticketId,
  });

  final int ticketId;
}

class UpdateTicketEvent extends TicketEvent {
  UpdateTicketEvent({
    required this.ticket,
  });

  final UpdateTicketQuery ticket;
}

class GetMyTicketsEvent extends TicketEvent {}
