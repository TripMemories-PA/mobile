import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

import '../constants/my_colors.dart';

class SearchBarCustom extends StatelessWidget {
  const SearchBarCustom({
    super.key,
    required this.searchController,
    required this.context,
    required this.searching,
    required this.searchContent,
    this.hintText,
    required this.onSearch,
  });

  final TextEditingController searchController;
  final BuildContext context;
  final ValueNotifier<bool> searching;
  final ValueNotifier<String> searchContent;
  final String? hintText;
  final Function onSearch;

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
              hintText: hintText,
              suffixIcon: value.isEmpty
                  ? Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : IconButton(
                      onPressed: () {
                        searchContent.value = '';
                        searchController.clear();
                        searching.value = false;
                        onSearch('');
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                      ),
                    ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.all(10.0),
            ),
            onChanged: (value) {
              searching.value = value.isNotEmpty;
              searchContent.value = value;
              EasyDebounce.debounce('search_bar', Durations.medium1, () {
                onSearch(value);
              });
            },
          );
        },
      ),
    );
  }
}
