import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../num_extensions.dart';
import 'skeleton.dart';

class ShimmerFriendRequest extends StatelessWidget {
  const ShimmerFriendRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double containerWidth = constraints.maxWidth;
        final double containerHeight = constraints.maxWidth;
        return Container(
          height: containerHeight * 0.2,
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
            padding: const EdgeInsets.all(8.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Row(
                children: [
                  CircleSkeleton(size: containerWidth * 0.10),
                  (containerWidth * 0.05).pw,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Skeleton(
                        width: containerWidth * 0.32,
                        height: containerHeight * 0.025,
                      ),
                      (containerHeight * 0.02).ph,
                      Skeleton(
                        width: containerWidth * 0.2,
                        height: containerHeight * 0.025,
                      ),
                    ],
                  ),
                  (containerWidth * 0.05).pw,
                  CircleSkeleton(size: containerWidth * 0.10),
                  (containerWidth * 0.05).pw,
                  CircleSkeleton(size: containerWidth * 0.10),
                  (containerWidth * 0.05).pw,
                  CircleSkeleton(size: containerWidth * 0.10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
