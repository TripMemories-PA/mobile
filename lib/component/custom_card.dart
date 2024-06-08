import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    this.width,
    this.height,
    required this.content,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.onTap,
  });

  final double? width;
  final double? height;
  final Widget content;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    if (onTap != null) {
      return InkWell(
        onTap: onTap as void Function()?,
        child: _buildContent(),
      );
    }
    return _buildContent();
  }

  Container _buildContent() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 15.0),
        border: Border.all(
          color: borderColor ?? Colors.black,
        ),
        color: backgroundColor ?? Colors.white,
      ),
      child: Center(child: content),
    );
  }
}
