import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc/auth_bloc.dart';
import '../bloc/auth_bloc/auth_state.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/ticket_bloc/ticket_bloc.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/ticket.dart';
import '../utils/messenger.dart';
import 'bouncing_widget.dart';
import 'custom_card.dart';
import 'popup/confirmation_dialog.dart';
import 'popup/modify_ticket_popup.dart';

class TicketCardAdmin extends StatelessWidget {
  const TicketCardAdmin({
    super.key,
    required this.article,
    this.onlyDemo = false,
    this.buyButton,
  });

  final Ticket article;
  final bool onlyDemo;
  final Widget? buyButton;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      borderColor: Theme.of(context).colorScheme.tertiary,
      content: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  _buildTicketImage(context),
                  if (context.read<AuthBloc>().state.status ==
                          AuthStatus.authenticated &&
                      context.read<AuthBloc>().state.user?.poiId ==
                          article.poi.id)
                    _buildActionsButtons(context),
                ],
              ),
            ),
            10.ph,
            AutoSizeText(
              article.title,
              minFontSize: 5,
              maxLines: 2,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            10.ph,
            AutoSizeText(
              article.description,
              minFontSize: 2,
              maxFontSize: 10,
              maxLines: 3,
            ),
            10.ph,
            Row(
              children: [
                Text(
                  '${article.price} €',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                  ),
                ),
                const Spacer(),
                Column(
                  children: [
                    10.ph,
                    Row(
                      children: [
                        Icon(
                          Icons.bolt_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        Text(
                          '${article.quantity} ${article.quantity > 1 ? StringConstants().leftTickets : StringConstants().leftTicket}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (context.read<AuthBloc>().state.status ==
                            AuthStatus.authenticated &&
                        context.read<AuthBloc>().state.user?.userTypeId != 3 &&
                        !onlyDemo)
                      buyButton ?? _buildAddToCartButton(context),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BouncingWidget _buildAddToCartButton(BuildContext context) {
    return BouncingWidget(
      onTap: () {
        Messenger.showSnackBarSuccess(
          StringConstants().addedToCart,
        );
        context.read<CartBloc>().add(
              AddArticle(
                article,
              ),
            );
      },
      child: Container(
        height: 40,
        width: 150,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(
            35,
          ),
        ),
        child: Center(
          child: Text(
            StringConstants().addArticle,
            style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
          ),
        ),
      ),
    );
  }

  Positioned _buildActionsButtons(BuildContext context) {
    return Positioned(
      right: 10,
      top: 10,
      child: Column(
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              modifyArticlePopup(
                context: context,
                article: article,
                ticketBloc: context.read<TicketBloc>(),
              ).then((bool result) {
                if (result) {
                  Messenger.showSnackBarSuccess(
                    StringConstants().modifiedArticle,
                  );
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await confirmationPopUp(
                context,
                title: StringConstants().doYouReallyWantToDeleteThisArticle,
                isOkPopUp: false,
              ).then((bool result) {
                if (result && context.mounted) {
                  context.read<TicketBloc>().add(
                        DeleteTicketEvent(
                          ticketId: article.id,
                        ),
                      );
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Stack _buildTicketImage(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              15,
            ),
            child: Image.network(
              article.poi.cover.url,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(
              211,
              211,
              211,
              0.7,
            ),
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          width: double.infinity,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width * 0.05,
            ),
            child: Image.asset('assets/images/ticket.png'),
          ),
        ),
      ],
    );
  }
}
