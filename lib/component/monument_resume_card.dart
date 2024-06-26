import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:progressive_image/progressive_image.dart';

import '../num_extensions.dart';
import '../object/poi/poi.dart';
import 'searching_monuments_body.dart';

class MonumentResumeCard extends StatelessWidget {
  const MonumentResumeCard({
    super.key,
    required this.monument,
    this.bodySize = SearchingMonumentBodySize.large,
  });

  final Poi monument;
  final SearchingMonumentBodySize bodySize;

  @override
  Widget build(BuildContext context) {
    final num? averageRating = monument.averageNote;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          width: constraints.maxWidth / 2 - 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 125,
                width: constraints.maxWidth,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child:
                  LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      return ProgressiveImage(
                        placeholder: null,
                        // size: 1.87KB
                        thumbnail: const AssetImage('assets/images/placeholder.jpg'),
                        // size: 1.29MB
                        image: NetworkImage(monument.cover.url),
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
                monument.city?.name ?? '',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 10,
                ),
              ),
              Text(
                monument.name,
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
                    allowHalfRating: true,
                    ignoreGestures: true,
                    itemSize:
                        bodySize == SearchingMonumentBodySize.large ? 19 : 14,
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
                    '(${monument.postsCount} avis)',
                    style: TextStyle(
                      fontSize:
                          bodySize == SearchingMonumentBodySize.large ? 11 : 9,
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
