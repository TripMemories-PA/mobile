import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../constants/string_constants.dart';
import '../../num_extensions.dart';
import '../../object/ticket.dart';
import '../../utils/messenger.dart';
import '../custom_card.dart';

class ArticleFormPopup extends HookWidget {
  const ArticleFormPopup({
    super.key,
    this.article,
  });

  final Ticket? article;

  @override
  Widget build(BuildContext context) {
    final articleTitleController =
        useTextEditingController(text: article?.title);
    final articleDescriptionController =
        useTextEditingController(text: article?.description);
    final articlePriceController =
        useTextEditingController(text: article?.price.toString());
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Builder(
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            child: SingleChildScrollView(
              child: CustomCard(
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.83,
                content: SizedBox.expand(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
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
                          height: 200,
                          child: Builder(
                            builder: (context) {
                              return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  image: DecorationImage(
                                    image: FileImage(
                                      File('assets/images/ticket.png'),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        10.ph,
                        Column(
                          children: [
                            Form(
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: articleTitleController,
                                    decoration: InputDecoration(
                                      hintText: StringConstants().title,
                                    ),
                                  ),
                                  10.ph,
                                  TextFormField(
                                    controller: articleDescriptionController,
                                    decoration: InputDecoration(
                                      hintText: StringConstants().description,
                                    ),
                                    maxLines: 10,
                                  ),
                                  10.ph,
                                  TextFormField(
                                    controller: articlePriceController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      hintText: StringConstants().price,
                                    ),
                                  ),
                                  20.ph,
                                  CustomCard(
                                    height: 50,
                                    content: Text(
                                      article != null
                                          ? StringConstants().modifyArticle
                                          : StringConstants().addArticle,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      ),
                                    ),
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    onTap: () {
                                      if (article != null) {
                                        Messenger.showSnackBarSuccess(
                                          'Modify article',
                                        );
                                        context.pop(true);
                                      } else {
                                        Messenger.showSnackBarSuccess(
                                          'Add article',
                                        );
                                        context.pop(true);
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
}) async {
  return await showDialog<bool>(
        context: context,
        builder: (_) => ArticleFormPopup(
          article: article,
        ),
      ) ??
      false;
}
