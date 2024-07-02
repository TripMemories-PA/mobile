import 'package:flutter/material.dart';

import '../component/article_card.dart';
import '../component/popup/modify_article_popup.dart';
import '../constants/string_constants.dart';
import '../object/article.dart';
import '../utils/messenger.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConstants().myProducts),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          modifyArticlePopup(
            context: context,
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
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ArticleCardAdmin(article: tmpArticles[index]);
          },
          itemCount: tmpArticles.length,
        ),
      ),
    );
  }
}

Article tmpArticle = Article(
  title: 'title hb kb hblhib lhb ib h kj mo  kj jk mkj mk , m mkj k:j k:j kj ',
  description:
      'description description description description description description description description description',
  imageUrl: 'https://picsum.photos/250?image=9',
  price: 10.0,
  museumId: 1,
  stock: 10,
  id: 1,
);

List<Article> tmpArticles = [
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
];
