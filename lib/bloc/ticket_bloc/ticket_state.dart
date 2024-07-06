part of 'ticket_bloc.dart';

enum TicketStatus { loading, notLoading, error, ticketPosted }

class TicketState {
  const TicketState({
    this.tickets,
    this.status = TicketStatus.notLoading,
    this.selectedTicket,
  });

  TicketState copyWith({
    List<Ticket>? tickets,
    TicketStatus? status,
    Ticket? selectedTicket,
  }) {
    return TicketState(
      tickets: tickets ?? this.tickets,
      status: status ?? this.status,
      selectedTicket: selectedTicket ?? this.selectedTicket,
    );
  }

  final List<Ticket>? tickets;
  final Ticket? selectedTicket;
  final TicketStatus status;
}
