import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/city_bloc/city_bloc.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';
import 'searching_cities_body.dart';

class SearchByCity extends HookWidget {
  const SearchByCity({super.key});

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
            'assets/images/panorama_city.jpeg',
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
                  text: TextSpan(
                    text: '${StringConstants().discoverTheIncredible} ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: GoogleFonts.urbanist().fontFamily,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: StringConstants().cities,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.urbanist().fontFamily,
                        ),
                      ),
                      TextSpan(
                        text: ' ${StringConstants().thatFranceIsHiding}',
                        style: TextStyle(
                          fontFamily: GoogleFonts.urbanist().fontFamily,
                        ),
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
