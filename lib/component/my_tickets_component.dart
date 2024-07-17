import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../bloc/ticket_bloc/ticket_bloc.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/bought_ticket.dart';
import 'custom_card.dart';

class MyTicketsComponent extends StatelessWidget {
  const MyTicketsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketBloc, TicketState>(
      builder: (context, state) {
        return Column(
          children: [
            if (state.myTickets == null)
              const Center(child: Text('Pas encore de ticket'))
            else
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: state.myTickets!.map((ticket) {
                    return Column(
                      children: [
                        TicketCard(
                          ticket: ticket,
                        ),
                        10.ph,
                      ],
                    );
                  }).toList(),
                ),
              ),
          ],
        );
      },
    );
  }
}

class TicketCard extends StatelessWidget {
  const TicketCard({super.key, required this.ticket});

  final BoughtTicket ticket;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          children: [
            30.ph,
            Stack(
              children: [
                SizedBox(
                  height: 200.0,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      ticket.ticket.poi.cover.url,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(211, 211, 211, 0.7),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: CustomCard(
                            height: 450,
                            width: 400,
                            content: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  QrImageView(
                                    data: ticket.qrCode,
                                    size: 300.0,
                                    embeddedImage: const AssetImage(
                                      'assets/images/app_logo_qr_code_light.png',
                                    ),
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text(StringConstants().close),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      child: Text(StringConstants().showQrCode),
                    ),
                  ),
                ),
              ],
            ),
            20.ph,
            Text('${StringConstants().ticketFor} ${ticket.ticket.poi.name}'),
            20.ph,
            Text(
              ticket.usedAt != null
                  ? StringConstants().usedTicket
                  : StringConstants().notUsedTicket,
              style: TextStyle(
                color: ticket.usedAt != null ? Colors.red : Colors.green,
              ),
            ),
            20.ph,
          ],
        ),
      ),
    );
  }
}
