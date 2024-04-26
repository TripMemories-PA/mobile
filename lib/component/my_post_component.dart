import 'package:flutter/material.dart';
import 'package:trip_memories_mobile/component/custom_card.dart';

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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  const Text('14/05/2024', style: TextStyle(fontSize: 20),),
                  const Expanded(child: SizedBox()),
                  Row(
                    children: List.generate(
                      5,
                      (index) => const Icon(Icons.star, color: Colors.yellow),
                    ).toList(),
                  ),
                ],
              ),
            ),
            const Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla nec odio nec nisl tincidunt tincidunt",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 10,
            ),

            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(15.0),
              ),
              child: Image.asset('assets/images/paris.jpeg'),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(onPressed: () => print('coucou'), icon: const Icon(Icons.favorite_border)),
                Text('NB LIKES'),
                const SizedBox(width: 5),
                IconButton(onPressed: () => print('coucou'), icon: const Icon(Icons.chat_bubble_outline)),
                Text('NB COMM'),
                const Expanded(child: SizedBox()),
                IconButton(onPressed: () => print('coucou'), icon: const Icon(Icons.delete)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
