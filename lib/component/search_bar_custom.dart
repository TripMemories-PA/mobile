import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_searching_bloc/user_searching_bloc.dart';
import '../constants/my_colors.dart';

class SearchBarCustom extends StatelessWidget {
  const SearchBarCustom({
    super.key,
    required this.searchController,
    required this.context,
    required this.searching,
    required this.searchContent,
    this.hintText,
  });

  final TextEditingController searchController;
  final BuildContext context;
  final ValueNotifier<bool> searching;
  final ValueNotifier<String> searchContent;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MyColors.darkGrey),
      ),
      child: ValueListenableBuilder(
        valueListenable: searchContent,
        builder: (context, value, child) {
          return TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher des amis',
              suffixIcon: value.isEmpty
                  ? Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        searchContent.value = '';
                        searchController.clear();
                        searching.value = false;
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                      ),
                    ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(10.0),
            ),
            //TODO: je prie
            onChanged: (value) {
              searching.value = value.isNotEmpty;
              searchContent.value = value;
              EasyDebounce.debounce('search_bar', Durations.medium1, () {
                context.read<UserSearchingBloc>().add(
                      SearchUsersEvent(
                        isRefresh: true,
                        searchingCriteria: value,
                      ),
                    );
              });
            },
          );
        },
      ),
    );
  }
}
