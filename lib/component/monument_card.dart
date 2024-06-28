import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import '../object/poi/poi.dart';
import 'custom_card.dart';

class MonumentCard extends StatelessWidget {
  const MonumentCard({super.key, required this.monument});

  final Poi monument;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      content: Column(
        children: [
          CachedNetworkImage(
            imageUrl: monument.cover.url,
            placeholder: (context, url) => const CupertinoActivityIndicator(),
            errorWidget: (context, url, error) =>
                const Icon(CupertinoIcons.exclamationmark_triangle),
          ),
          Text(monument.name),
          Text(monument.description ?? ''),
        ],
      ),
    );
  }
}
