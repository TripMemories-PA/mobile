import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';

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
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ValueListenableBuilder(
        valueListenable: searchContent,
        builder: (context, value, child) {
          return TextField(
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            textAlignVertical: TextAlignVertical.center,
            controller: searchController,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              suffixIcon: value.isEmpty
                  ? Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onSurface,
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
