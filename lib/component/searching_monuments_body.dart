import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../bloc/monument_bloc/monument_bloc.dart';
import '../constants/my_colors.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import 'monument_resume_list.dart';
import 'search_bar_custom.dart';

enum SearchingMonumentBodySize { small, large }

class SearchingMonumentBody extends HookWidget {
  const SearchingMonumentBody({
    super.key,
    this.needToPop = false,
    this.padding = 0.0,
    this.bodySize = SearchingMonumentBodySize.large,
    required this.searchController,
    required this.searchContent,
    required this.searching,
    required this.monumentsScrollController,
  });

  final bool needToPop;
  final double padding;
  final SearchingMonumentBodySize bodySize;
  final TextEditingController searchController;
  final ValueNotifier<String> searchContent;
  final ValueNotifier<bool> searching;
  final ScrollController monumentsScrollController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Column(
        children: [
          SearchBarCustom(
            searchController: searchController,
            context: context,
            searching: searching,
            searchContent: searchContent,
            hintText: StringConstants().searchMonuments,
            onSearch: (value) {
              context.read<MonumentBloc>().add(
                    GetMonumentsEvent(
                      searchingCriteria: value,
                      isRefresh: true,
                    ),
                  );
            },
          ),
          10.ph,
          Expanded(child: _buildSearchMonumentList(searchContent)),
        ],
      ),
    );
  }

  BlocBuilder<MonumentBloc, MonumentState> _buildSearchMonumentList(
    ValueNotifier<String> searchContent,
  ) {
    return BlocBuilder<MonumentBloc, MonumentState>(
      builder: (context, state) {
        if (state.status == MonumentStatus.error) {
          return _buildErrorWidget(context);
        } else if (state.status == MonumentStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.monuments.isEmpty) {
          return Text(StringConstants().noMonumentFound);
        } else {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${state.monuments.length} ${StringConstants().result}${state.monuments.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: MyColors.darkGrey,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: MonumentResumeList(
                  monuments: state.monuments,
                  needToPop: needToPop,
                  bodySize: bodySize,
                  monumentsScrollController: monumentsScrollController,
                ),
              ),
              Center(
                child: state.searchMonumentsHasMoreMonuments
                    ? (state.status != MonumentStatus.error
                        ? const Text(
                            'SHIMMER HERE',
                          ) // TODO(nono): Add Shimmer effect here
                        : _buildErrorWidget(context))
                    : Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(StringConstants().noMoreMonuments),
                      ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Column(
      children: [
        Text(StringConstants().errorAppendedWhileGettingData),
        ElevatedButton(
          onPressed: () => _getMonumentsRequest(context),
          child: Text(StringConstants().retry),
        ),
      ],
    );
  }

  void _getMonumentsRequest(BuildContext context) {
    context.read<MonumentBloc>().add(
          GetMonumentsEvent(
            isRefresh: true,
            searchingCriteria: searchContent.value,
          ),
        );
  }
}
