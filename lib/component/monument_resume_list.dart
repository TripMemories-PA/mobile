import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/route_name.dart';
import '../object/poi/poi.dart';
import 'monument_resume_card.dart';
import 'searching_monuments_body.dart';

class MonumentResumeList extends StatelessWidget {
  const MonumentResumeList({
    super.key,
    required this.monuments,
    this.needToPop = false,
    this.bodySize = SearchingMonumentBodySize.large,
    required this.monumentsScrollController,
  });

  final List<Poi> monuments;
  final bool needToPop;
  final SearchingMonumentBodySize bodySize;
  final ScrollController monumentsScrollController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GridView.builder(
          cacheExtent: 60,
          controller: monumentsScrollController,
          padding: const EdgeInsets.all(10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 15.0,
            childAspectRatio: constraints.maxWidth / 2 / 200,
          ),
          itemCount: monuments.length,
          itemBuilder: (context, index) {
            final monument = monuments[index];
            return GestureDetector(
              onTap: () => needToPop
                  ? context.pop(monument)
                  : context.push(
                      '${RouteName.monumentPage}/${monument.id}',
                    ),
              child: MonumentResumeCard(
                monument: monument,
                bodySize: bodySize,
              ),
            );
          },
        );
      },
    );
  }
}
