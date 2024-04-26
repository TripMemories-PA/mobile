import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/my_colors.dart';
import 'custom_card.dart';

class MyFriendsComponent extends StatelessWidget {
  const MyFriendsComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomCard(
              width: MediaQuery.of(context).size.width * 0.40,
              height: 40,
              content: const Text(
                'Ajouter un amis',
                textAlign: TextAlign.center,
              ),
              borderColor: MyColors.purple,
            ),
            CustomCard(
              width: MediaQuery.of(context).size.width * 0.40,
              height: 40,
              content: const Text(
                'Gérer les demandes',
                textAlign: TextAlign.center,
              ),
              borderColor: MyColors.purple,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        _buildFriendsList(context),
      ],
    );
  }

  Widget _buildFriendsList(BuildContext context) {
    return Column(
      children: List.generate(15, (index) {
        return Column(
          children: [
            _buildFriendCard(context),
            const SizedBox(height: 10),
          ],
        );
      }),
    );
  }


  CustomCard _buildFriendCard(BuildContext context) {
    return CustomCard(
      width: MediaQuery.of(context).size.width * 0.90,
      height: 55,
      borderColor: MyColors.lightGrey,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const SizedBox(width: 12,),
              SizedBox(
                width: 40,
                height: 40,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50.0),
                  ),
                  child: Image.asset('assets/images/profileSample.png'),
                ),
              ),
              const SizedBox(width: 10),
              const Column(
                children: [
                  Text(
                    'Jane Doe',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '@jane_doe',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              SizedBox(
                width: 30,
                height: 30,
                child: IconButton(
                  iconSize: 15,
                  onPressed: () => print('coucou'),
                  icon: const Icon(Icons.chat),
                  color: Colors.white,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(MyColors.purple),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: 30,
                height: 30,
                child: IconButton(
                  iconSize: 15,
                  onPressed: () => print('coucou'),
                  icon: const Icon(Icons.remove_red_eye),
                  color: Colors.white,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(MyColors.purple),
                  ),
                ),
              ),
              const SizedBox(width: 30),
            ],
          ),
        ],
      ),
    );
  }
}
