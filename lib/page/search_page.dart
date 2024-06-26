import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../bloc/monument_bloc/monument_bloc.dart';
import '../../repository/monument/monument_repository.dart';
import '../../service/monument/monument_remote_data_source.dart';
import '../bloc/city_bloc/city_bloc.dart';
import '../component/search_by_city.dart';
import '../component/search_by_monument.dart';
import '../constants/string_constants.dart';
import '../repository/city/cities_repository.dart';
import '../service/cities/cities_remote_data_source.dart';

class SearchPage extends HookWidget {
  const SearchPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MonumentRepository>(
          create: (context) => MonumentRepository(
            monumentRemoteDataSource: MonumentRemoteDataSource(),
            // TODO(nono): Implement ProfileLocalDataSource
            //profilelocalDataSource: ProfileLocalDataSource(),
          ),
        ),
        RepositoryProvider<CityRepository>(
          create: (context) => CityRepository(
            citiesRemoteDataSource: CityRemoteDataSource(),
            // TODO(nono): Implement ProfileLocalDataSource
            //profilelocalDataSource: ProfileLocalDataSource(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MonumentBloc(
              monumentRepository:
                  RepositoryProvider.of<MonumentRepository>(context),
            )..add(
                GetMonumentsEvent(
                  isRefresh: true,
                ),
              ),
          ),
          BlocProvider(
            create: (context) => CityBloc(
              cityRepository: RepositoryProvider.of<CityRepository>(context),
            )..add(
                GetCitiesEvent(
                  isRefresh: true,
                ),
              ),
          ),
        ],
        child: const SlidePage(),
      ),
    );
  }
}

class SlidePage extends HookWidget {
  const SlidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = usePageController();
    final citySearchSelected = useState(false);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Container(
          height: 30,
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: ToggleButtons(
            onPressed: (int index) {
              citySearchSelected.value = index == 1;
              pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            borderColor: Theme.of(context).colorScheme.onSecondary,
            selectedColor: Theme.of(context).colorScheme.onPrimary,
            fillColor: Theme.of(context).colorScheme.primary,
            color: Theme.of(context).colorScheme.onSecondary,
            selectedBorderColor: Theme.of(context).colorScheme.onSecondary,
            constraints: const BoxConstraints(
              minHeight: 30.0,
              minWidth: 180.0,
            ),
            isSelected:
                citySearchSelected.value ? [false, true] : [true, false],
            children: <Widget>[
              Text(StringConstants().searchByName),
              Text(StringConstants().searchByCity),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const SearchByMonument(),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const SearchByCity(),
          ),
        ],
      ),
    );
  }
}
