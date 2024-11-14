import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../bloc/monument_bloc/monument_bloc.dart';
import '../constants/my_colors.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import 'monument_resume_list.dart';
import 'search_bar_custom.dart';
import 'shimmer/shimmer_post_and_monument_resume_grid.dart';

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
            hintText: StringConstants.searchMonuments,
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
          Expanded(
            child: _SearchMonumentList(
              searchContent: searchContent,
              request: () => _getMonumentsRequest(context),
              monumentsScrollController: monumentsScrollController,
              bodySize: bodySize,
              needToPop: needToPop,
            ),
          ),
        ],
      ),
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

class _NoMoreMonument extends StatelessWidget {
  const _NoMoreMonument();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(15.0),
      child: Text(StringConstants.noMoreMonuments),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(StringConstants.errorAppendedWhileGettingData),
        ElevatedButton(
          onPressed: () => onPressed(),
          child: const Text(StringConstants.retry),
        ),
      ],
    );
  }
}

class _SearchMonumentList extends StatelessWidget {
  const _SearchMonumentList({
    required this.searchContent,
    required this.request,
    required this.monumentsScrollController,
    required this.bodySize,
    required this.needToPop,
  });

  final ValueNotifier<String> searchContent;
  final VoidCallback request;
  final ScrollController monumentsScrollController;
  final SearchingMonumentBodySize bodySize;
  final bool needToPop;

  @override
  Widget build(BuildContext context) {
    print('SearchMonumentList building');
    return BlocBuilder<MonumentBloc, MonumentState>(
      builder: (context, state) {
        if (state.status == MonumentStatus.error) {
          return _ErrorWidget(
            onPressed: () => request(),
          );
        } else if (state.status == MonumentStatus.loading) {
          return const Center(child: ShimmerPostAndMonumentResumeGrid());
        } else if (state.monuments.isEmpty) {
          return const Text(StringConstants.noMonumentFound);
        } else {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${state.monuments.length} ${StringConstants.result}${state.monuments.length > 1 ? 's' : ''}',
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
                    ? (state.searchingMonumentByNameStatus ==
                            MonumentStatus.loading
                        ? SpinKitThreeBounce(
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 20,
                          )
                        : (state.status == MonumentStatus.error
                            ? _ErrorWidget(
                                onPressed: () => request(),
                              )
                            : const SizedBox.shrink()))
                    : const _NoMoreMonument(),
              ),
            ],
          );
        }
      },
    );
  }
}
