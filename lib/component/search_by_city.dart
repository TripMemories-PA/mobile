import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:trip_memories_mobile/component/searching_cities_body.dart';

import '../bloc/city_bloc/city_bloc.dart';
import '../num_extensions.dart';

class SearchByName extends HookWidget {
  const SearchByName({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = useTextEditingController();
    final searching = useState(false);
    final searchContent = useState('');
    final ScrollController citiesScrollController = useScrollController();
    useEffect(
      () {
        void createScrollListener() {
          if (citiesScrollController.position.atEdge) {
            if (citiesScrollController.position.pixels != 0) {
              _getMonuments(context, searchContent.value);
            }
          }
        }

        citiesScrollController.addListener(createScrollListener);
        return () =>
            citiesScrollController.removeListener(createScrollListener);
      },
      const [],
    );
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CityBloc>().add(
              GetCitiesEvent(
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
            child: SearchingCityBody(
              padding: 20,
              searchController: searchController,
              searchContent: searchContent,
              searching: searching,
              monumentsScrollController: citiesScrollController,
            ),
          ),
        ],
      ),
    );
  }

  void _getMonuments(BuildContext context, String searchContent) {
    final monumentBloc = context.read<CityBloc>();

    if (monumentBloc.state.status != CityStatus.loading) {
      monumentBloc.add(
        GetCitiesEvent(searchingCriteria: searchContent),
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
            'assets/images/panorama.png',
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
                        text: 'monuments',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' dont recèle la France',
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
