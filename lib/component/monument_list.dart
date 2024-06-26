import 'package:flutter/material.dart';

import '../object/poi/poi.dart';
import 'monument_resume_card.dart';

class MonumentList extends StatelessWidget {
  const MonumentList({super.key, required this.monuments});

  final List<Poi> monuments;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: monuments
          .map(
            (monument) => MonumentResumeCard(
              monument: monument,
            ),
          )
          .toList(),
    );
  }
}
