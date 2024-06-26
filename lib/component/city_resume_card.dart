import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:progressive_image/progressive_image.dart';

import '../num_extensions.dart';
import '../object/city/city.dart';
import 'searching_cities_body.dart';

class CityResumeCard extends StatelessWidget {
  const CityResumeCard({
    super.key,
    required this.city,
    this.bodySize = SearchingCityBodySize.large,
  });

  final City city;
  final SearchingCityBodySize bodySize;

  @override
  Widget build(BuildContext context) {
    final num? averageRating = city.averageNote;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          height: 300,
          width: constraints.maxWidth / 2 - 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 125,
                width: constraints.maxWidth,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return ProgressiveImage(
                        placeholder: null,
                        // size: 1.87KB
                        thumbnail:
                            const AssetImage('assets/images/placeholder.jpg'),
                        // size: 1.29MB
                        image: NetworkImage(city.cover?.url ?? ''),
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              5.ph,
              Text(
                city.name,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onTertiary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RatingBar(
                    glow: false,
                    initialRating:
                        averageRating != null ? averageRating.toDouble() : 0,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 1.5),
                    minRating: 1,
                    maxRating: 5,
                    updateOnDrag: true,
                    allowHalfRating: true,
                    itemSize: bodySize == SearchingCityBodySize.large ? 19 : 14,
                    ignoreGestures: true,
                    ratingWidget: RatingWidget(
                      full: Icon(
                        Icons.star,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      half: Icon(
                        Icons.star_half,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      empty: Icon(
                        Icons.star_border_outlined,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    onRatingUpdate: (double value) {},
                  ),
                  Text(
                    '(${city.postsCount ?? 0} avis)',
                    style: TextStyle(
                      fontSize:
                          bodySize == SearchingCityBodySize.large ? 11 : 9,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
