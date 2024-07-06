import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/ticket/ticket_service.dart';
import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/ticket_bloc/ticket_bloc.dart';
import '../component/popup/modify_article_popup.dart';
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
              title: Text(StringConstants().myProducts),
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                modifyArticlePopup(
                  context: context,
                  ticketBloc: context.read<TicketBloc>(),
                ).then((bool result) {
                  if (result) {
                    Messenger.showSnackBarSuccess(
                      'Article created',
                    );
                  }
                });
              },
              child: const Icon(Icons.add),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocListener<TicketBloc, TicketState>(
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
                  }
                },
                child: Builder(
                  builder: (context) {
                    if (state.tickets == null) {
                      return Center(
                        child: Text(StringConstants().noTicketForThisMonument),
                      );
                    }
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 440,
                          child:
                              TicketCardAdmin(article: state.tickets![index]),
                        );
                      },
                      itemCount: state.tickets?.length,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
