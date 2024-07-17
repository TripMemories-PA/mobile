import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../api/ticket/model/query/post_ticket_query.dart';
import '../../api/ticket/model/query/update_ticket_query.dart';
import '../../bloc/ticket_bloc/ticket_bloc.dart';
import '../../constants/string_constants.dart';
import '../../num_extensions.dart';
import '../../object/ticket.dart';
import '../../utils/field_validator.dart';
import '../custom_card.dart';

class TicketFormPopup extends HookWidget {
  const TicketFormPopup({
    super.key,
    this.article,
    required this.ticketBloc,
  });

  final Ticket? article;
  final TicketBloc ticketBloc;

  @override
  Widget build(BuildContext context) {
    final articleTitleController =
        useTextEditingController(text: article?.title);
    final articleDescriptionController =
        useTextEditingController(text: article?.description);
    final articlePriceController =
        useTextEditingController(text: article?.price.toString());
    final quantityController =
        useTextEditingController(text: article?.quantity.toString());
    final groupSizeController =
        useTextEditingController(text: article?.groupSize.toString());
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Builder(
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            child: CustomCard(
              width: MediaQuery.of(context).size.width * 0.90,
              height: MediaQuery.of(context).size.height * 0.8,
              content: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          Text(
                            article != null
                                ? StringConstants().modifyArticle
                                : StringConstants().addArticle,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          CustomCard(
                            width: 100,
                            content: Text(
                              StringConstants().close,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            onTap: () {
                              context.pop();
                            },
                          ),
                        ],
                      ),
                      20.ph,
                      SizedBox(
                        height: 75,
                        child: Builder(
                          builder: (context) {
                            return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Image.asset('assets/images/ticket.png'),
                            );
                          },
                        ),
                      ),
                      10.ph,
                      Column(
                        children: [
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: articleTitleController,
                                  decoration: InputDecoration(
                                    hintText: StringConstants().title,
                                  ),
                                  validator: (value) =>
                                      FieldValidator.validateRequired(
                                    value: value,
                                  ),
                                ),
                                10.ph,
                                TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: articleDescriptionController,
                                  decoration: InputDecoration(
                                    hintText: StringConstants().description,
                                  ),
                                  maxLines: 10,
                                  validator: (value) =>
                                      FieldValidator.validateRequired(
                                    value: value,
                                  ),
                                ),
                                10.ph,
                                TextFormField(
                                  controller: articlePriceController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: StringConstants().price,
                                  ),
                                  validator: (value) =>
                                      FieldValidator.validateRequired(
                                    value: value,
                                  ),
                                ),
                                TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: quantityController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: StringConstants().quantity,
                                  ),
                                  validator: (value) =>
                                      FieldValidator.validateRequired(
                                    value: value,
                                  ),
                                ),
                                TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: groupSizeController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: StringConstants().groupSize,
                                  ),
                                  validator: (value) =>
                                      FieldValidator.validateRequired(
                                    value: value,
                                  ),
                                ),
                                20.ph,
                                CustomCard(
                                  height: 50,
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        article != null
                                            ? StringConstants().modifyArticle
                                            : StringConstants().addArticle,
                                        style: TextStyle(
                                          color: ticketBloc.state.status ==
                                                  TicketStatus.loading
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .tertiary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                        ),
                                      ),
                                      if (ticketBloc.state.status ==
                                          TicketStatus.loading)
                                        const CupertinoActivityIndicator(),
                                    ],
                                  ),
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  onTap: () {
                                    final Ticket? tmp = article;
                                    if (formKey.currentState!.validate()) {
                                      if (tmp != null) {
                                        final UpdateTicketQuery ticket =
                                            UpdateTicketQuery(
                                          id: tmp.id,
                                          title: articleTitleController.text,
                                          description:
                                              articleDescriptionController.text,
                                          price: double.parse(
                                            articlePriceController.text,
                                          ),
                                          quantity: int.parse(
                                            quantityController.text,
                                          ),
                                          groupSize: int.parse(
                                            groupSizeController.text,
                                          ),
                                        );
                                        ticketBloc.add(
                                          UpdateTicketEvent(
                                            ticket: ticket,
                                          ),
                                        );
                                        context.pop(true);
                                      } else {
                                        final PostTicketQuery ticket =
                                            PostTicketQuery(
                                          title: articleTitleController.text,
                                          description:
                                              articleDescriptionController.text,
                                          price: double.parse(
                                            articlePriceController.text,
                                          ),
                                          quantity: int.parse(
                                            quantityController.text,
                                          ),
                                          groupSize: int.parse(
                                            groupSizeController.text,
                                          ),
                                        );
                                        ticketBloc.add(
                                          PostTicketEvent(
                                            ticket: ticket,
                                          ),
                                        );
                                        context.pop(true);
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<bool> modifyArticlePopup({
  required BuildContext context,
  Ticket? article,
  required TicketBloc ticketBloc,
}) async {
  return await showDialog<bool>(
        context: context,
        builder: (_) => TicketFormPopup(
          article: article,
          ticketBloc: ticketBloc,
        ),
      ) ??
      false;
}
