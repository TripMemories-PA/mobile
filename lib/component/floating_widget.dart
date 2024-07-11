import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FloatingWidget extends HookWidget {
  const FloatingWidget({
    super.key,
    required this.child,
    this.animationDuration,
    this.animationRange,
  });

  final Widget child;
  final int? animationDuration;
  final Tween<double>? animationRange;

  @override
  Widget build(BuildContext context) {
    final AnimationController controller = useAnimationController(
      duration: Duration(seconds: animationDuration ?? 1),
    )..repeat(reverse: true);

    final Animation<double> animation =
        (animationRange ?? Tween<double>(begin: -5.0, end: 5.0)).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0.0, animation.value),
          child: child,
        );
      },
      child: child,
    );
  }
}
