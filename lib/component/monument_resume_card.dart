import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/monument/model/response/poi/poi.dart';

class MonumentResumeCard extends StatelessWidget {
  const MonumentResumeCard({super.key, required this.monument});

  final Poi monument;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          color: Colors.blue,
          height: 200,
          width: constraints.maxWidth / 2 - 5,
          child: Column(
            children: [
              SizedBox(
                height: 125,
                width: constraints.maxWidth,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: CachedNetworkImage(
                    imageUrl: monument.cover.url,
                    placeholder: (context, url) =>
                        const CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(CupertinoIcons.exclamationmark_triangle),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(monument.city),
              Text(monument.name),
              Text(monument.rating.toString()),
            ],
          ),
        );
      },
    );
  }
}
