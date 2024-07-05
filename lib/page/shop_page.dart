import 'package:flutter/material.dart';

import '../component/popup/modify_article_popup.dart';
import '../component/ticket_card.dart';
import '../constants/string_constants.dart';
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
              child: TicketCardAdmin(article: tmpArticles[index]),
            );
          },
          itemCount: tmpArticles.length,
        ),
      ),
    );
  }
}
