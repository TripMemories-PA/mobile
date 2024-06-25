import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../num_extensions.dart';
import 'skeleton.dart';

class ShimmerPost extends StatelessWidget {
  const ShimmerPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 320,
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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Skeleton(
                height: 130,
              ),
            ),
            10.ph,
            Row(
              children: [
                const Skeleton(width: 150),
                10.pw,
                const Spacer(),
                10.pw,
                const Skeleton(width: 100),
                10.pw,
              ],
            ),
            10.ph,
            const Skeleton(
              width: 250,
            ),
            10.ph,
            const Skeleton(),
            10.ph,
            const Skeleton(
              width: 200,
            ),
            10.ph,
            Row(
              children: [
                const CircleSkeleton(size: 50),
                10.pw,
                const Skeleton(
                  width: 150,
                ),
                const Spacer(),
                const CircleSkeleton(
                  size: 50,
                ),
                10.pw,
                const CircleSkeleton(
                  size: 50,
                ),
                10.pw,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
