import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../object/ticket.dart';
import 'ticket_card.dart';

class TicketTabView extends StatefulWidget {
  const TicketTabView({super.key, required this.tickets});

  final List<Ticket> tickets;

  @override
  State<TicketTabView> createState() => _TicketTabViewState();
}

class _TicketTabViewState extends State<TicketTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tickets.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: (context.read<AuthBloc>().state.user?.userTypeId == 3 ||
                  context.read<AuthBloc>().state.status == AuthStatus.guest)
              ? 380
              : 420,
          child: TabBarView(
            controller: _tabController,
            children: widget.tickets.map((ticket) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TicketCardAdmin(
                  article: ticket,
                ),
              );
            }).toList(),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: TabPageSelector(
            controller: _tabController,
            selectedColor: Theme.of(context).colorScheme.primary,
            color: Theme.of(context).colorScheme.tertiary,
            borderStyle: BorderStyle.none,
          ),
        ),
      ],
    );
  }
}
