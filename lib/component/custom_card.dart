import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {super.key,
      required this.width,
      required this.heigth,
      required this.content,
      this.backgroundColor});

  final double width;
  final double heigth;
  final Widget content;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: heigth,
      color: backgroundColor ?? Colors.white,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(),
      ),
      child: content,
    );
  }
}
