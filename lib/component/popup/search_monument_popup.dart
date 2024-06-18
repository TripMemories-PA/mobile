import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../api/monument/model/response/poi/poi.dart';
import '../../bloc/monument_bloc/monument_bloc.dart';
import '../../constants/my_colors.dart';
import '../../constants/string_constants.dart';
import '../../num_extensions.dart';
import '../../repository/monument_repository.dart';
import '../../service/monument/monument_remote_data_source.dart';
import '../custom_card.dart';
import '../monument_resume_list.dart';
import '../search_bar_custom.dart';

class SearchMonumentPopup extends StatelessWidget {
  const SearchMonumentPopup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<MonumentRepository>(
      create: (context) => MonumentRepository(
        monumentRemoteDataSource: MonumentRemoteDataSource(),
        // TODO(nono): Implement ProfileLocalDataSource
        //profilelocalDataSource: ProfileLocalDataSource(),
      ),
      child: BlocProvider(
        create: (context) => MonumentBloc(
          monumentRepository:
              RepositoryProvider.of<MonumentRepository>(context),
        )..add(GetMonumentsEvent()),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Builder(
            builder: (context) => Dialog(
              child: CustomCard(
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.81,
                content: SizedBox.expand(
                  child: Stack(
                    children: [
                      const SearchingMonumentBody(),
                      Positioned(
                        top: 30,
                        right: 10,
                        child: SizedBox(
                          height: 25,
                          child: ElevatedButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text('Fermer'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchingMonumentBody extends HookWidget {
  const SearchingMonumentBody({super.key});

  void _getMonuments(BuildContext context) {
    final monumentBloc = context.read<MonumentBloc>();

    if (monumentBloc.state.status != MonumentStatus.loading) {
      monumentBloc.add(
        GetMonumentsEvent(isRefresh: false),
      );
    }
  }

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
              _getMonuments(context);
            }
          }
        }

        monumentsScrollController.addListener(createScrollListener);
        return () =>
            monumentsScrollController.removeListener(createScrollListener);
      },
      const [],
    );
    return SingleChildScrollView(
      controller: monumentsScrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            _buildTitle(
              context,
              searching,
              searchController,
              searchContent,
            ),
            SearchBarCustom(
              searchController: searchController,
              context: context,
              searching: searching,
              searchContent: searchContent,
              hintText: 'Rechercher des monuments',
              onSearch: (value) {
                context.read<MonumentBloc>().add(
                      GetMonumentsEvent(
                        searchingCriteria: value,
                      ),
                    );
              },
            ),
            10.ph,
            _buildSearchMonumentList(searchContent),
          ],
        ),
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
        } else if (state.searchingMonumentByNameStatus ==
            MonumentStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.monuments == null) {
          return const Text('Aucun monument trouvé');
        } else {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${state.monuments?.length} résultat${state.monuments!.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: MyColors.darkGrey,
                    ),
                  ),
                ),
              ),
              if (state.searchingMonumentByNameStatus ==
                  MonumentStatus.notLoading)
                MonumentResumeList(monuments: state.monuments ?? [])
              else
                const CircularProgressIndicator(),
              Center(
                child: state.searchMonumentsHasMoreMonuments
                    ? (state.searchingMonumentByNameStatus !=
                            MonumentStatus.error
                        ? ElevatedButton(
                            onPressed: () {
                              context.read<MonumentBloc>().add(
                                    GetMonumentsEvent(
                                      isRefresh: false,
                                      searchingCriteria: searchContent.value,
                                    ),
                                  );
                            },
                            child: const Text('Voir plus de résultats'),
                          )

                        // TODO(nono): SHIMMER
                        : _buildErrorWidget(context))
                    : Text(StringConstants().noMoreMonuments),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildTitle(
    BuildContext context,
    ValueNotifier<bool> searching,
    TextEditingController searchController,
    ValueNotifier<String> searchContent,
  ) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Rechercher des monuments',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
          GetMonumentsEvent(),
        );
  }
}

Future<Poi?> searchMonumentPopup(
  BuildContext context,
) async =>
    showDialog<Poi>(
      context: context,
      builder: (_) => const SearchMonumentPopup(),
    );
