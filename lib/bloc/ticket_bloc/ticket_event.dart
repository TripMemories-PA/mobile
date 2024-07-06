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
