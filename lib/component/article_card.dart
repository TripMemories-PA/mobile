import 'package:flutter/material.dart';
import 'package:trip_memories_mobile/component/popup/modify_article_popup.dart';

import '../num_extensions.dart';
import '../object/article.dart';
import '../utils/messenger.dart';

class ArticleCardAdmin extends StatelessWidget {
  const ArticleCardAdmin({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
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
                            'Article modified',
                          );
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            10.ph,
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(article.title),
                    Text(article.description),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Price: ${article.price}'),
                    Text('Stock: ${article.stock}'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
