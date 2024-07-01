import 'package:flutter/material.dart';

import '../component/article_card.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../object/article.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConstants().myProducts),
        centerTitle: true,
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
  title: 'title',
  description: 'description',
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
  tmpArticle
];
