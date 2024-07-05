import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/exception/custom_exception.dart';
import '../../object/ticket.dart';
import '../../repository/ticket/i_tickets_repository.dart';

part 'ticket_event.dart';

part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  TicketBloc({
    required this.ticketRepository,
  }) : super(const TicketState()) {
    on<GetTicketsEvent>((event, emit) async {
      emit(state.copyWith(status: TicketStatus.loading));
      try {
        final List<Ticket> tickets =
            await ticketRepository.getTickets(event.monumentId);
        emit(
          state.copyWith(
            tickets: tickets.isEmpty ? null : tickets,
            status: TicketStatus.notLoading,
          ),
        );
      } catch (e) {
        if (e is CustomException) {
          emit(
            state.copyWith(
              status: TicketStatus.error,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: TicketStatus.error,
            ),
          );
        }
      }
    });
  }

  final ITicketRepository ticketRepository;
}
