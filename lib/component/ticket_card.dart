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
import 'custom_card.dart';
import 'popup/confirmation_logout_dialog.dart';
import 'popup/modify_article_popup.dart';

class TicketCardAdmin extends StatelessWidget {
  const TicketCardAdmin({
    super.key,
    required this.article,
  });

  final Ticket article;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return CustomCard(
          height: constraints.maxHeight,
          borderColor: Theme.of(context).colorScheme.tertiary,
          content: Padding(
            padding: EdgeInsets.all(constraints.maxWidth * 0.04),
            child: Column(
              children: <Widget>[
                Stack(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height: constraints.maxHeight * 0.5,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              constraints.maxHeight * 0.05,
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
                              constraints.maxHeight * 0.05,
                            ),
                          ),
                          height: constraints.maxHeight * 0.5,
                          width: double.infinity,
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.5,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              constraints.maxWidth * 0.05,
                            ),
                            child: Image.asset('assets/images/ticket.png'),
                          ),
                        ),
                      ],
                    ),
                    if (context.read<AuthBloc>().state.status ==
                            AuthStatus.authenticated &&
                        context.read<AuthBloc>().state.user?.poiId ==
                            article.poi.id)
                      Positioned(
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
                                  title: StringConstants()
                                      .doYouReallyWantToDeleteThisArticle,
                                  isOkPopUp: false,
                                ).then((bool result) {
                                  if (result) {
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
                      ),
                  ],
                ),
                (constraints.maxHeight * 0.01).toInt().ph,
                SizedBox(
                  height: constraints.maxHeight * 0.4,
                  child: Column(
                    children: [
                      AutoSizeText(
                        article.title,
                        minFontSize: 5,
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      5.ph,
                      AutoSizeText(
                        article.description,
                        minFontSize: 2,
                        maxFontSize: 10,
                        maxLines: 3,
                      ),
                      const Spacer(),
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
                              (constraints.maxHeight * 0.05).ph,
                              Row(
                                children: [
                                  Icon(
                                    Icons.bolt_outlined,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  Text(
                                    '${article.quantity} ${article.quantity > 1 ? StringConstants().leftTickets : StringConstants().leftTicket}',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              if (context.read<AuthBloc>().state.status ==
                                  AuthStatus.authenticated)
                                ElevatedButton(
                                  onPressed: () {
                                    Messenger.showSnackBarSuccess(
                                      StringConstants().addedToCart,
                                    );
                                    context.read<CartBloc>().add(
                                          AddArticle(
                                            article,
                                          ),
                                        );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                  ),
                                  child: Text(StringConstants().addArticle),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

/*IconButton _buildMoreDetailsButton(BuildContext context) {
    return IconButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          EdgeInsets.zero,
        ),
      ),
      onPressed: () => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(article.title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    '${StringConstants().description}: ${article.description}',
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(StringConstants().close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ),
      icon: const Icon(
        Icons.info,
      ),
    );
  }*/
}
