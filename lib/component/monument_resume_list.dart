import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../api/monument/model/response/poi/poi.dart';
import '../constants/route_name.dart';
import 'monument_resume_card.dart';
import 'searching_monuments_body.dart';

class MonumentResumeList extends StatelessWidget {
  const MonumentResumeList({
    super.key,
    required this.monuments,
    this.needToPop = false,
    this.bodySize = SearchingMonumentBodySize.large,
  });

  final List<Poi> monuments;
  final bool needToPop;
  final SearchingMonumentBodySize bodySize;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 15.0,
      children: monuments
          .map(
            (monument) => GestureDetector(
              onTap: () => needToPop
                  ? context.pop(monument)
                  : context.push(
                      '${RouteName.monumentPage}/${monument.id}',
                      extra: monument,
                    ),
              child: MonumentResumeCard(
                monument: monument,
                bodySize: bodySize,
              ),
            ),
          )
          .toList(),
    );
  }
}
