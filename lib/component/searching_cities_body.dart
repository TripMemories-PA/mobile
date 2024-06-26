import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../bloc/city_bloc/city_bloc.dart';
import '../bloc/monument_bloc/monument_bloc.dart';
import '../constants/my_colors.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import 'city_resume_list.dart';
import 'search_bar_custom.dart';
import 'shimmer/shimmer_post_and_monument_resume_grid.dart';

enum SearchingCityBodySize { small, large }

class SearchingCityBody extends HookWidget {
  const SearchingCityBody({
    super.key,
    this.needToPop = false,
    this.padding = 0.0,
    this.bodySize = SearchingCityBodySize.large,
    required this.searchController,
    required this.searchContent,
    required this.searching,
    required this.monumentsScrollController,
  });

  final bool needToPop;
  final double padding;
  final SearchingCityBodySize bodySize;
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
              context.read<CityBloc>().add(
                    GetCitiesEvent(
                      searchingCriteria: value,
                      isRefresh: true,
                    ),
                  );
            },
          ),
          10.ph,
          Expanded(child: _buildSearchCityList(searchContent)),
        ],
      ),
    );
  }

  BlocBuilder<CityBloc, CityState> _buildSearchCityList(
    ValueNotifier<String> searchContent,
  ) {
    return BlocBuilder<CityBloc, CityState>(
      builder: (context, state) {
        if (state.status == CityStatus.error) {
          return _buildErrorWidget(context);
        } else if (state.status == CityStatus.loading) {
          return const Center(child: ShimmerPostAndMonumentResumeGrid());
        } else if (state.cities.isEmpty) {
          return Text(StringConstants().noCityFound);
        } else {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${state.cities.length} ${StringConstants().result}${state.cities.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: MyColors.darkGrey,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: CityResumeList(
                  cities: state.cities,
                  needToPop: needToPop,
                  bodySize: bodySize,
                  citiesScrollController: monumentsScrollController,
                ),
              ),
              Center(
                child: state.searchCitiesHasMoreMonuments
                    ? (state.searchingCitiesByNameStatus == CityStatus.loading
                        ? SpinKitThreeBounce(
                            color: Theme.of(context).colorScheme.onSurface,
                            size: 20,
                          )
                        : (state.status == CityStatus.error
                            ? _buildErrorWidget(context)
                            : const SizedBox.shrink()))
                    : Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(StringConstants().noMoreCities),
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
