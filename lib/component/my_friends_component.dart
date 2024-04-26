import 'package:flutter/cupertino.dart';

import '../constants/my_colors.dart';
import 'custom_card.dart';

class MyFriendsComponent extends StatelessWidget {
  const MyFriendsComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomCard(
          width: MediaQuery.of(context).size.width * 0.40,
          heigth: 40,
          content: const Text(
            'Ajouter un amis',
            textAlign: TextAlign.center,
          ),
          borderColor: MyColors.purple,
        ),
        CustomCard(
          width: MediaQuery.of(context).size.width * 0.40,
          heigth: 40,
          content: const Text(
            'Gérer les demandes',
            textAlign: TextAlign.center,
          ),
          borderColor: MyColors.purple,
        ),
      ],
    );
  }
}
