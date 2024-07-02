import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trip_memories_mobile/component/popup/modify_article_popup.dart';

import '../bloc/cart/cart_bloc.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/article.dart';
import '../utils/messenger.dart';

class ArticleCardAdmin extends StatelessWidget {
  const ArticleCardAdmin({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(constraints.maxWidth * 0.05),
            child: Column(
              children: <Widget>[
                Stack(
                  children: [
                    SizedBox(
                      height: constraints.maxWidth * 0.5,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(constraints.maxWidth * 0.05),
                        child: Image.network(
                          article.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          modifyArticlePopup(
                            context: context,
                            article: article,
                          ).then((bool result) {
                            if (result) {
                              Messenger.showSnackBarSuccess(
                                StringConstants().modifiedArticle,
                              );
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
                10.ph,
                Column(
                  children: [
                    AutoSizeText(
                      article.title,
                      minFontSize: 5,
                      maxLines: 2,
                    ),
                    5.ph,
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
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
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Text(
                                '${StringConstants().price}: ${article.price}'),
                            5.ph,
                            Text(
                                '${StringConstants().stock}: ${article.stock}'),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () => {
                                  Messenger.showSnackBarSuccess(
                                      StringConstants().addedToCart),
                                  context
                                      .read<CartBloc>()
                                      .add(AddArticle(article)),
                                },
                            icon: const Icon(Icons.add_shopping_cart)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
