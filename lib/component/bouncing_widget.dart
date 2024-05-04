import 'package:flutter/cupertino.dart';

class BouncingWidget extends StatefulWidget {
  const BouncingWidget({super.key, required this.child, this.onTap});

  final Widget child;
  final Function? onTap;

  @override
  State<BouncingWidget> createState() => _BouncingWidgetState();
}

class _BouncingWidgetState extends State<BouncingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.8).animate(_controller);

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((value) => _controller.reverse());
    final Function? onTap = widget.onTap;
    if (onTap != null) {
      onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Transform.scale(
        scale: _animation.value,
        child: widget.child,
      ),
    );
  }
}
