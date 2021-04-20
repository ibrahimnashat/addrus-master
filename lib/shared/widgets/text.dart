import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MText extends StatelessWidget {
  dynamic text;
  final double size;
  final bool isBold;
  final Color color;
  final EdgeInsetsGeometry margin;
  final TextAlign align;
  final List<BoxShadow> shadow;
  final int maxLines;
  final bool isMedium;
  final String fontFamily;
  final double maxWidth;
  final bool isUpper;
  final TextDecoration decoration;

  MText(
      {this.color,
      this.decoration,
      this.margin,
      this.isBold = false,
      this.size = 12,
      this.fontFamily = "VarelaRound",
      this.isUpper = false,
      this.isMedium = false,
      this.maxWidth,
      this.text,
      this.maxLines,
      this.shadow,
      this.align = TextAlign.start});
  @override
  Widget build(BuildContext context) {
    if (text == null) {
      text = "";
    }
    return Container(
      width: maxWidth,
      margin: margin,
      child: Text(
        isUpper ? "$text".toUpperCase() : "$text",
        textAlign: align,
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
        style: TextStyle(
            decoration: decoration,
            shadows: shadow,
            fontSize: size,
            color: color,
            fontFamily: fontFamily,
            fontWeight: isBold
                ? FontWeight.bold
                : isMedium
                    ? FontWeight.w500
                    : FontWeight.normal),
      ),
    );
  }
}
