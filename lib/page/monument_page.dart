import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../api/monument/model/response/poi/poi.dart';

class MonumentPage extends StatelessWidget {
  const MonumentPage({super.key, required this.monument});

  final Poi monument;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: monument.cover.url,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Center(
                child: CircularProgressIndicator(
                  value: downloadProgress.progress,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const Text('Monument Page'),
            Text('Monument: ${monument.name}'),
          ],
        ),
      ),
    );
  }
}
