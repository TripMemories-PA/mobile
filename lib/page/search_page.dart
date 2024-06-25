import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../bloc/monument_bloc/monument_bloc.dart';
import '../../repository/monument/monument_repository.dart';
import '../../service/monument/monument_remote_data_source.dart';
import '../bloc/city_bloc/city_bloc.dart';
import '../component/search_by_city.dart';
import '../component/searching_monuments_body.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import '../repository/cities/cities_repository.dart';
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
              citiesRepository: RepositoryProvider.of<CityRepository>(context),
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
            child: const SearchByName(),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const _SearchByCity(),
          ),
        ],
      ),
    );
  }
}

class _SearchByCity extends HookWidget {
  const _SearchByCity();

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = useTextEditingController();
    final searching = useState(false);
    final searchContent = useState('');
    final ScrollController monumentsScrollController = useScrollController();
    useEffect(
      () {
        void createScrollListener() {
          if (monumentsScrollController.position.atEdge) {
            if (monumentsScrollController.position.pixels != 0) {
              _getMonuments(context, searchContent.value);
            }
          }
        }

        monumentsScrollController.addListener(createScrollListener);
        return () =>
            monumentsScrollController.removeListener(createScrollListener);
      },
      const [],
    );
    return RefreshIndicator(
      onRefresh: () async {
        context.read<MonumentBloc>().add(
              GetMonumentsEvent(
                isRefresh: true,
                searchingCriteria: searchContent.value,
              ),
            );
      },
      child: Column(
        children: [
          _buildHeader(),
          20.ph,
          Expanded(
            child: SearchingMonumentBody(
              padding: 20,
              searchController: searchController,
              searchContent: searchContent,
              searching: searching,
              monumentsScrollController: monumentsScrollController,
            ),
          ),
        ],
      ),
    );
  }

  void _getMonuments(BuildContext context, String searchContent) {
    final monumentBloc = context.read<MonumentBloc>();

    if (monumentBloc.state.status != MonumentStatus.loading) {
      monumentBloc.add(
        GetMonumentsEvent(searchingCriteria: searchContent),
      );
    }
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 180,
          child: Image.asset(
            'assets/images/panorama_city.png',
            fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            30.ph,
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    text: 'Découvre les incroyables ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'villes',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' que cache la France',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
