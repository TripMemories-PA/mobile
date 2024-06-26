import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../num_extensions.dart';
import 'skeleton.dart';

class ShimmerPostAndMonumentResume extends StatelessWidget {
  const ShimmerPostAndMonumentResume({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double containerWidth = constraints.maxWidth;
        final double containerHeight = constraints.maxWidth;

        return Container(
          height: containerHeight * 0.85,
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
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: containerWidth * 0.03,
              vertical: containerHeight * 0.03,
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(containerWidth * 0.02),
                    child: Skeleton(
                      height: containerHeight * 0.4,
                    ),
                  ),
                  SizedBox(height: containerHeight * 0.02),
                  Row(
                    children: [
                      Skeleton(
                        width: containerWidth * 0.4,
                        height: containerHeight * 0.05,
                      ),
                      const Spacer(),
                      Skeleton(
                        width: containerWidth * 0.25,
                        height: containerHeight * 0.05,
                      ),
                    ],
                  ),
                  (containerHeight * 0.05).ph,
                  Skeleton(
                    width: containerWidth * 0.65,
                    height: containerHeight * 0.05,
                  ),
                  (containerHeight * 0.03).ph,
                  Skeleton(height: containerHeight * 0.05),
                  (containerHeight * 0.03).ph,
                  Skeleton(height: containerHeight * 0.05),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
