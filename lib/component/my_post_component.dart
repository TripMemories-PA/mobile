import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import '../constants/my_colors.dart';
import 'custom_card.dart';

class MyPostsComponents extends StatelessWidget {
  const MyPostsComponents({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildPostList(context);
  }

  Widget _buildPostList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: List.generate(15, (index) {
          return Column(
            children: [
              _buildPostCard(context),
              const SizedBox(height: 10),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildPostCard(BuildContext context) {
    return CustomCard(
      content: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                  child: Image.asset('assets/images/paris.jpeg'),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Column(
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star,
                            color: MyColors.purple,
                          ),
                        ).toList(),
                      ),
                      const Text(
                        '(1245 avis)',
                        style: TextStyle(color: MyColors.purple),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Paris, France',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Une vue incroyable !',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    )
                  ],
                ),
                const Expanded(child: SizedBox()),
                SizedBox(
                  height: 30,
                  width: 30,
                  child: IconButton(
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.remove_red_eye_outlined,
                      color: Colors.white,
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(MyColors.purple),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla nec odio nec nisl tincidunt tincidunt',
              style: TextStyle(fontSize: 15),
            ),
            Row(
              children: [
                IconButton(
                  color: MyColors.purple,
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                const Text(
                  'NB LIKES',
                  style: TextStyle(color: MyColors.purple),
                ),
                const SizedBox(width: 5),
                IconButton(
                  color: MyColors.purple,
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () {},
                ),
                const Text(
                  'NB COMM',
                  style: TextStyle(color: MyColors.purple),
                ),
                const Expanded(child: SizedBox()),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
