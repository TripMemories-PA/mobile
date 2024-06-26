import 'package:flutter/cupertino.dart';

import '../../num_extensions.dart';
import 'shimmer_post_and_monument_resume.dart';

class ShimmerPostAndMonumentResumeList extends StatelessWidget {
  const ShimmerPostAndMonumentResumeList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const ShimmerPostAndMonumentResume(),
          10.ph,
          const ShimmerPostAndMonumentResume(),
          10.ph,
          const ShimmerPostAndMonumentResume(),
          10.ph,
          const ShimmerPostAndMonumentResume(),
          10.ph,
          const ShimmerPostAndMonumentResume(),
          10.ph,
        ],
      ),
    );
  }
}
