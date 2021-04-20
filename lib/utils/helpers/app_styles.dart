import 'package:flutter/material.dart';

import '../size_config.dart';
import 'app_colors.dart';

class AppStyles {
  //decoration

  static BoxDecoration decorationBottomShadow() =>
      BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
        BoxShadow(
            color: Colors.lightBlueAccent,
            blurRadius: 5.0,
            offset: Offset(0.0, 0.5))
      ]);

  static BoxDecoration decorationBottomBorder(
          Color borderColor, double borderWidth,
          [Color bkgColor]) =>
      BoxDecoration(
        color: (null != bkgColor) ? bkgColor : null,
        border: Border(
            bottom: BorderSide(
          //                   <--- left side
          color: borderColor,
          width: borderWidth,
        )),
      );

  static BoxDecoration decorationTop([double radius, Color bkg, double shadowOffset]) =>
      BoxDecoration(
          color: (null != bkg) ? bkg : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius * SizeConfig.heightMultiplier),
            topRight: Radius.circular(radius * SizeConfig.heightMultiplier),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: AppColors.GRAY_MED,
                blurRadius: (null != shadowOffset)? shadowOffset :6,
                spreadRadius: 0.0,
                offset: Offset(0.0, (null != shadowOffset)? shadowOffset : 5))
          ]);

  static BoxDecoration decorationRoundedColored(
          Color bkgColor, double borderRadius) =>
      BoxDecoration(
        color: bkgColor,
        borderRadius:
            BorderRadius.circular(borderRadius * SizeConfig.heightMultiplier),
      );

  static BoxDecoration decorationRoundedColoredShadow(
          Color bkgColor, double borderRadius,
          [Color shadowColor, double blurRadius, double offset]) =>
      BoxDecoration(
          color: bkgColor,
          borderRadius:
              BorderRadius.circular(borderRadius * SizeConfig.heightMultiplier),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: (null != shadowColor)
                    ? shadowColor
                    : AppColors.GRAY_SHADOW,
                blurRadius: (null != blurRadius) ? blurRadius : 3,
                spreadRadius: 0.0,
                offset: Offset(0.0, (null != offset) ? offset : 5))
          ]);

  static BoxDecoration decorationRoundedColoredBorder(Color bkgColor,
          double borderRadius, Color borderColor, double borderWidth) =>
      BoxDecoration(
        color: bkgColor,
        borderRadius:
            BorderRadius.circular(borderRadius * SizeConfig.heightMultiplier),
        border: Border.all(color: borderColor, width: borderWidth),
      );

  static BoxDecoration circleDecoration(Color bkgColor) => BoxDecoration(
        color: bkgColor,
        shape: BoxShape.circle,
      );

  static BoxDecoration gradientBlueDarkDecoration() =>
      BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.BLUE_Light, AppColors.BLUE_DARK2],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            tileMode: TileMode.repeated
        ),
      );

  static BoxDecoration gradientWhiteGrayDarkDecoration() =>
      BoxDecoration(
        color: Colors.white,
        gradient: LinearGradient(
            colors: [Colors.white, AppColors.GRAY_SHADOW],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            tileMode: TileMode.mirror,
        ),
      );
  //-----------------------------------------------------

  static LinearGradient linearGradient = LinearGradient(
    colors: [AppColors.PRIMARY, AppColors.PRIMARY],
  );

//  padding
  static EdgeInsets paddingSymmetric(double horizontal, double vertical) =>
      EdgeInsets.symmetric(
          horizontal: horizontal * SizeConfig.heightMultiplier,
          vertical: vertical * SizeConfig.heightMultiplier);

  static EdgeInsets paddingAll(
          double left, double top, double right, double bottom) =>
      EdgeInsets.fromLTRB(
          left * SizeConfig.heightMultiplier,
          top * SizeConfig.heightMultiplier,
          right * SizeConfig.heightMultiplier,
          bottom * SizeConfig.heightMultiplier);

  static EdgeInsets paddingLRT(double value) => EdgeInsets.only(
      left: value * SizeConfig.heightMultiplier,
      right: value * SizeConfig.heightMultiplier,
      top: value * SizeConfig.heightMultiplier);
}
