import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../api/monument/model/response/poi/poi.dart';
import 'monument_resume_card.dart';

class MonumentResumeList extends StatelessWidget {
  const MonumentResumeList({super.key, required this.monuments, this.needToPop = false});

  final List<Poi> monuments;
  final bool needToPop;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: monuments
          .map(
            (monument) => GestureDetector(
              onTap: () => context.pop(monument),
              child: MonumentResumeCard(monument: monument),
            ),
          )
          .toList(),
    );
  }
}
