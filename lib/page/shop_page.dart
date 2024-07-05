import 'package:flutter/material.dart';

import '../component/popup/modify_article_popup.dart';
import '../component/ticket_card.dart';
import '../constants/string_constants.dart';
import '../object/ticket.dart';
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
            return SizedBox(
                height: 440,
                child: TicketCardAdmin(article: tmpArticles[index]));
          },
          itemCount: tmpArticles.length,
        ),
      ),
    );
  }
}

Ticket tmpArticle = Ticket(
  title: 'title hb kb hblhib lhb ib h kj mo  kj jk mkj mk , m mkj k:j k:j kj ',
  description:
      'description description description description description description description description description',
  price: 10.0,
  museumId: 1,
  stock: 10,
  id: 1,
);

List<Ticket> tmpArticles = [
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
  tmpArticle,
];
