part of 'ticket_bloc.dart';

enum TicketStatus {
  loading,
  notLoading,
  error,
  ticketPosted,
  ticketDeleted,
  ticketUpdated,
}

class TicketState {
  const TicketState({
    this.tickets,
    this.status = TicketStatus.notLoading,
    this.selectedTicket,
    this.myTickets,
    this.error,
  });

  TicketState copyWith({
    List<Ticket>? tickets,
    TicketStatus? status,
    Ticket? selectedTicket,
    List<BoughtTicket>? myTickets,
    ApiError? error,
  }) {
    return TicketState(
      tickets: tickets ?? this.tickets,
      status: status ?? this.status,
      selectedTicket: selectedTicket ?? this.selectedTicket,
      myTickets: myTickets ?? this.myTickets,
      error: error ?? this.error,
    );
  }

  final List<Ticket>? tickets;
  final Ticket? selectedTicket;
  final TicketStatus status;
  final List<BoughtTicket>? myTickets;
  final ApiError? error;
}
