import 'package:flutter/cupertino.dart';

import 'shimmer_post_and_monument_resume.dart';

class ShimmerPostAndMonumentResumeGrid extends StatelessWidget {
  const ShimmerPostAndMonumentResumeGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
      children: const [
        ShimmerPostAndMonumentResume(),
        ShimmerPostAndMonumentResume(),
        ShimmerPostAndMonumentResume(),
        ShimmerPostAndMonumentResume(),
        ShimmerPostAndMonumentResume(),
        ShimmerPostAndMonumentResume(),
        ShimmerPostAndMonumentResume(),
        ShimmerPostAndMonumentResume(),
        ShimmerPostAndMonumentResume(),
        ShimmerPostAndMonumentResume(),
        ShimmerPostAndMonumentResume(),
        ShimmerPostAndMonumentResume(),
      ],
    );
  }
}
