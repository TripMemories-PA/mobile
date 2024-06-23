import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/monument_bloc/monument_bloc.dart';
import '../../constants/string_constants.dart';
import '../../object/poi/poi.dart';
import '../../repository/monument/monument_repository.dart';
import '../../service/monument/monument_remote_data_source.dart';
import '../custom_card.dart';
import '../searching_monuments_body.dart';

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
        )..add(GetMonumentsEvent(isRefresh: true)),
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          body: _Body(),
        ),
      ),
    );
  }
}

class _Body extends HookWidget {
  const _Body();

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
    return Builder(
      builder: (context) => Dialog(
        child: CustomCard(
          width: MediaQuery.of(context).size.width * 0.90,
          height: MediaQuery.of(context).size.height * 0.81,
          content: SizedBox.expand(
            child: Stack(
              children: [
                RefreshIndicator(
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
                      _buildTitle(),
                      Expanded(
                        child: SearchingMonumentBody(
                          needToPop: true,
                          padding: 10,
                          bodySize: SearchingMonumentBodySize.small,
                          searchController: searchController,
                          searchContent: searchContent,
                          searching: searching,
                          monumentsScrollController: monumentsScrollController,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 30,
                  right: 10,
                  child: SizedBox(
                    height: 25,
                    child: ElevatedButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: Text(StringConstants().close),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          StringConstants().searchMonuments,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
