import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/route_name.dart';
import '../object/city/city.dart';
import 'city_resume_card.dart';
import 'searching_cities_body.dart';

class CityResumeList extends StatelessWidget {
  const CityResumeList({
    super.key,
    required this.cities,
    this.needToPop = false,
    this.bodySize = SearchingCityBodySize.large,
    required this.citiesScrollController,
  });

  final List<City> cities;
  final bool needToPop;
  final SearchingCityBodySize bodySize;
  final ScrollController citiesScrollController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GridView.builder(
          controller: citiesScrollController,
          padding: const EdgeInsets.all(10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 15.0,
            childAspectRatio: constraints.maxWidth / 2 / 200,
          ),
          itemCount: cities.length,
          itemBuilder: (context, index) {
            final city = cities[index];
            return GestureDetector(
              onTap: () => needToPop
                  ? context.pop(city)
                  : context.push(
                      '${RouteName.cityPage}/${city.id}',
                      extra: city,
                    ),
              child: CityResumeCard(
                city: city,
                bodySize: bodySize,
              ),
            );
          },
        );
      },
    );
  }
}
