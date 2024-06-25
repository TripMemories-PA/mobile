import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'skeleton.dart';

import '../../num_extensions.dart';

class ShimmerFriendRequest extends StatelessWidget {
  const ShimmerFriendRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Row(
        children: [
          const SizedBox(
            height: 60,
            width: 60,
            child: CircleSkeleton(),
          ),
          10.pw,
          Expanded(
            child: Column(
              children: [
                10.ph,
                Row(
                  children: [
                    const Skeleton(width: 80),
                    10.pw,
                    const Skeleton(width: 80),
                    10.pw,
                    const Expanded(child: Skeleton()),
                    10.ph,
                  ],
                ),
                10.ph,
                Row(
                  children: [
                    const Skeleton(width: 70),
                    10.pw,
                    10.ph,
                    const Expanded(child: Skeleton(width: 10)),
                  ],
                ),
                10.ph,
                const Skeleton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
