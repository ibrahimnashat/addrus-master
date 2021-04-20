import 'package:flutter/material.dart';
import 'package:adrus/shared/imports.dart';

class MFillButton extends StatelessWidget {
  final name;
  final onTap;
  final Color color;
  final Color colorText;
  final double radius;
  final width;
  final height;
  final textSize;
  final Widget widget;
  MFillButton(
      {this.name,
      this.onTap,
      this.textSize,
      this.height,
      this.color = const Color(0xffff9442),
      this.width,
      this.colorText = Colors.white,
      this.radius = 0,
      this.widget});
  @override
  Widget build(BuildContext context) {
    final w = context.width;
    return TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          primary: MColors.appColor,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius))),
        ),
        child: widget ??
            Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              child: MText(
                size: textSize ?? w * 0.035,
                text: name,
                color: colorText,
                isBold: true,
              ).mPadding(
                  horizontal: width == null ? w * 0.04 : 0,
                  vertical: height == null ? w * 0.008 : 0),
            ));
  }
}

class MOutlineButton extends StatelessWidget {
  final name;
  final onTap;
  final double radius;
  final Widget widget;
  MOutlineButton({this.name, this.onTap, this.radius, this.widget});
  @override
  Widget build(BuildContext context) {
    final w = context.width;
    return TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          side: BorderSide(color: MColors.appColor, width: 2),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 25))),
        ),
        child: widget ??
            MText(
              text: name,
              size: w * 0.042,
              color: MColors.appColor,
              isBold: true,
            ).mPadding(horizontal: w * 0.02, vertical: w * 0.008));
  }
}
