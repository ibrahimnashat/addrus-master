import 'dart:math';

import 'package:flutter/material.dart';
import 'package:adrus/shared/imports.dart';

extension OnWidget on Widget {
  Widget mFlap() {
    return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: this);
  }

  Widget mPadding(
      {double end = 0,
      double start = 0,
      double top = 0,
      double bottom = 0,
      double all = 0,
      double horizontal = 0,
      double vertical = 0}) {
    return Padding(
      padding: EdgeInsets.all(all),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: Padding(
          padding: EdgeInsetsDirectional.only(
              end: end, start: start, top: top, bottom: bottom),
          child: this,
        ),
      ),
    );
  }

  Widget mCircle({Color color = Colors.transparent}) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: color), shape: BoxShape.circle),
      child: ClipRRect(
        child: this,
        borderRadius: BorderRadius.circular(500),
      ),
    );
  }

  Widget mRadius({BorderRadius radius = BorderRadius.zero}) {
    return ClipRRect(
      child: this,
      borderRadius: radius,
    );
  }

  Widget mTap({Function onTap}) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: this,
      onTap: onTap,
    );
  }

  Positioned get zeroPositions {
    return Positioned(left: 0, right: 0, top: 0, bottom: 0, child: this);
  }

  Widget addBackground({String name = "background", width, height}) {
    return Container(
        width: width,
        color: Colors.white,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            MImage(
              def: name,
            ).zeroPositions,
            this,
          ],
        ));
  }
}
