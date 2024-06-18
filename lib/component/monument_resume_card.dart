import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/monument/model/response/poi/poi.dart';
import 'custom_card.dart';

class MonumentResumeCard extends StatelessWidget {
  const MonumentResumeCard({super.key, required this.monument});

  final Poi monument;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      backgroundColor: Colors.blue,
      height: 200,
      content: Row(
        children: [
          SizedBox(
            width: 100,
            height: 200,
            child: CachedNetworkImage(
              imageUrl: monument.cover.url,
              placeholder: (context, url) => const CupertinoActivityIndicator(),
              errorWidget: (context, url, error) =>
                  const Icon(CupertinoIcons.exclamationmark_triangle),
            ),
          ),
          Text(monument.name),
        ],
      ),
    );
  }
}
