import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.width,
    required this.heigth,
    required this.content,
    this.backgroundColor,
    this.borderColor,
  });

  final double width;
  final double heigth;
  final Widget content;
  final Color? backgroundColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: heigth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: borderColor ?? Colors.black,
        ),
        color: backgroundColor ?? Colors.white,
      ),
      child: Center(child: content),
    );
  }
}
