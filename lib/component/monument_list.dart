import 'package:flutter/material.dart';

import '../api/monument/model/response/poi/poi.dart';
import 'monument_card.dart';

class MonumentList extends StatelessWidget {
  const MonumentList({super.key, required this.monuments});

  final List<Poi> monuments;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: monuments
          .map(
            (monument) => MonumentCard(monument: monument),
          )
          .toList(),
    );
  }
}
