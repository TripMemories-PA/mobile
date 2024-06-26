import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
                  child: Image.network(
                    city.cover?.url ?? '',
                    loadingBuilder: (
                      BuildContext context,
                      Widget child,
                      ImageChunkEvent? loadingProgress,
                    ) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      }
                    },
                    errorBuilder: (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) {
                      return const Icon(
                        CupertinoIcons.exclamationmark_triangle,
                      );
                    },
                    fit: BoxFit.cover,
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
