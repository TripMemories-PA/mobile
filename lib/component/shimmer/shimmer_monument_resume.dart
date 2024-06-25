import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../num_extensions.dart';
import 'skeleton.dart';

class ShimmerMonumentResume extends StatelessWidget {
  const ShimmerMonumentResume({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double containerWidth = constraints.maxWidth;
        double containerHeight = constraints.maxHeight;

        return Container(
          height: containerHeight * 0.85, // exemple d'ajustement dynamique de hauteur
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(containerWidth * 0.02),
                  child: Skeleton(
                    height: containerHeight * 0.4, // ajustement dynamique
                  ),
                ),
                SizedBox(height: containerHeight * 0.03), // ajustement dynamique
                Row(
                  children: [
                    Skeleton(width: containerWidth * 0.4), // ajustement dynamique
                    SizedBox(width: containerWidth * 0.03), // ajustement dynamique
                    const Spacer(),
                    SizedBox(width: containerWidth * 0.03), // ajustement dynamique
                    Skeleton(width: containerWidth * 0.25), // ajustement dynamique
                    SizedBox(width: containerWidth * 0.03), // ajustement dynamique
                  ],
                ),
                SizedBox(height: containerHeight * 0.03), // ajustement dynamique
                Skeleton(
                  width: containerWidth * 0.65, // ajustement dynamique
                ),
                SizedBox(height: containerHeight * 0.03), // ajustement dynamique
                Skeleton(),
                SizedBox(height: containerHeight * 0.03), // ajustement dynamique
                Skeleton(
                  width: containerWidth * 0.5, // ajustement dynamique
                ),
                SizedBox(height: containerHeight * 0.03), // ajustement dynamique
                Row(
                  children: [
                    CircleSkeleton(size: containerWidth * 0.1), // ajustement dynamique
                    SizedBox(width: containerWidth * 0.03), // ajustement dynamique
                    Skeleton(
                      width: containerWidth * 0.4, // ajustement dynamique
                    ),
                    const Spacer(),
                    CircleSkeleton(
                      size: containerWidth * 0.1, // ajustement dynamique
                    ),
                    SizedBox(width: containerWidth * 0.03), // ajustement dynamique
                    CircleSkeleton(
                      size: containerWidth * 0.1, // ajustement dynamique
                    ),
                    SizedBox(width: containerWidth * 0.03), // ajustement dynamique
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
