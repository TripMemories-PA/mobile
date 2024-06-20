import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SlideAnimationWidget extends HookWidget {
  const SlideAnimationWidget({
    super.key,
    required this.child,
    this.animationDuration,
    this.isRightToLeft,
    this.animationController,
  });

  final Widget child;
  final int? animationDuration;
  final bool? isRightToLeft;
  final AnimationController? animationController;

  @override
  Widget build(BuildContext context) {
    final controller = animationController ??
        useAnimationController(
          duration: Duration(seconds: animationDuration ?? 1),
        );
    final slideFromRightToLeft = isRightToLeft ?? false;
    final offsetAnimation = useMemoized(
      () {
        return Tween<Offset>(
          begin: Offset.zero,
          end: Offset(slideFromRightToLeft ? -5 : 5, 0.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeInBack,
          ),
        );
      },
      [controller],
    );

    useEffect(
      () {
        if (animationController == null) {
          controller.forward();
        }
        return controller.dispose;
      },
      [controller],
    );

    return SlideTransition(
      position: offsetAnimation,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
