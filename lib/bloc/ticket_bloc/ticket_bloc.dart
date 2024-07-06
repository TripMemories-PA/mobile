import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/exception/custom_exception.dart';
import '../../api/ticket/i_ticket_service.dart';
import '../../api/ticket/model/query/post_ticket_query.dart';
import '../../api/ticket/model/query/update_ticket_query.dart';
import '../../object/ticket.dart';
import '../../repository/ticket/i_tickets_repository.dart';

part 'ticket_event.dart';
part 'ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  TicketBloc({
    required this.ticketRepository,
    required this.ticketService,
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

    on<PostTicketEvent>((event, emit) async {
      emit(state.copyWith(status: TicketStatus.loading));
      try {
        await ticketService.postTicket(ticket: event.ticket);
        emit(
          state.copyWith(
            status: TicketStatus.ticketPosted,
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

    on<DeleteTicketEvent>((event, emit) async {
      emit(state.copyWith(status: TicketStatus.loading));
      try {
        await ticketService.deleteTicket(ticketId: event.ticketId);
        emit(
          state.copyWith(
            status: TicketStatus.ticketDeleted,
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

    on<UpdateTicketEvent>((event, emit) async {
      emit(state.copyWith(status: TicketStatus.loading));
      try {
        await ticketService.updateTicket(ticket: event.ticket);
        emit(
          state.copyWith(
            status: TicketStatus.ticketUpdated,
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
  final ITicketService ticketService;
}
