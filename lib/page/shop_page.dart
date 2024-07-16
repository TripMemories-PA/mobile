import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/ticket/ticket_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/ticket_bloc/ticket_bloc.dart';
import '../component/popup/modify_ticket_popup.dart';
import '../component/ticket_card.dart';
import '../constants/string_constants.dart';
import '../repository/ticket/ticket_repository.dart';
import '../utils/messenger.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TicketBloc(
        ticketRepository: RepositoryProvider.of<TicketRepository>(
          context,
        ),
        ticketService: TicketService(),
      )..add(
          GetTicketsEvent(
            monumentId: context.read<AuthBloc>().state.user?.poiId,
          ),
        ),
      child: BlocBuilder<TicketBloc, TicketState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: Text(
                StringConstants().myProducts,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              ),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                modifyArticlePopup(
                  context: context,
                  ticketBloc: context.read<TicketBloc>(),
                );
              },
              child: const Icon(Icons.add),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocConsumer<TicketBloc, TicketState>(
                listener: (context, state) {
                  if (state.status == TicketStatus.ticketPosted) {
                    Messenger.showSnackBarSuccess(
                      StringConstants().ticketPosted,
                    );
                    context.read<TicketBloc>().add(
                          GetTicketsEvent(
                            monumentId:
                                context.read<AuthBloc>().state.user?.poiId,
                          ),
                        );
                  } else if (state.status == TicketStatus.ticketDeleted) {
                    Messenger.showSnackBarSuccess(
                      StringConstants().ticketDeleted,
                    );
                    context.read<TicketBloc>().add(
                          GetTicketsEvent(
                            monumentId:
                                context.read<AuthBloc>().state.user?.poiId,
                          ),
                        );
                  } else if (state.status == TicketStatus.ticketUpdated) {
                    Messenger.showSnackBarSuccess(
                      StringConstants().ticketUpdated,
                    );
                    context.read<TicketBloc>().add(
                          GetTicketsEvent(
                            monumentId:
                                context.read<AuthBloc>().state.user?.poiId,
                          ),
                        );
                  }
                },
                builder: (context, state) {
                  if (state.tickets == null) {
                    return Center(
                      child: Text(StringConstants().noTicketForThisMonument),
                    );
                  }
                  if (state.status == TicketStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<TicketBloc>().add(
                            GetTicketsEvent(
                              monumentId:
                                  context.read<AuthBloc>().state.user?.poiId,
                            ),
                          );
                    },
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              TicketCardAdmin(article: state.tickets![index]),
                        );
                      },
                      itemCount: state.tickets?.length,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
