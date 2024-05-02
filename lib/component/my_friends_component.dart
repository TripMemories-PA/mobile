import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/profile/response/friends/get_friends_pagination_response.dart';
import '../bloc/profile/profile_bloc.dart';
import '../constants/my_colors.dart';
import '../object/profile/profile.dart';
import 'custom_card.dart';

class MyFriendsComponent extends StatelessWidget {
  const MyFriendsComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (context.read<ProfileBloc>().state.status ==
                ProfileStatus.loading) {
              return const CircularProgressIndicator();
            } else {
              return _buildFriendsList(context);
            }
          },
        ),
      ],
    );
  }

  Widget _buildFriendsList(BuildContext context) {
    final List<Profile>? friends =
        context.read<ProfileBloc>().state.friends?.data;
    if (friends == null || friends.isEmpty) {
      return const Center(child: Text('Aucun amis ajouté'));
    }
    return Flexible(
      child: ListView(
        padding: const EdgeInsets.only(top: 10, bottom: 100),
        children: context
                .read<ProfileBloc>()
                .state
                .friends
                ?.data
                .map(
                  (friend) => _buildFriendCard(context, friend),
                )
                .toList() ??
            [],
      ),
    );
  }

  CustomCard _buildFriendCard(BuildContext context, Profile friend) {
    return CustomCard(
      width: MediaQuery.of(context).size.width * 0.90,
      height: 55,
      borderColor: MyColors.lightGrey,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 12,
              ),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    backgroundColor:
                        MaterialStateProperty.all<Color>(MyColors.purple),
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
                    backgroundColor:
                        MaterialStateProperty.all<Color>(MyColors.purple),
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
