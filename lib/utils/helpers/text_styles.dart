import 'package:flutter/material.dart';

import '../size_config.dart';
import 'app_fonts.dart';

class AppTextStyles {

  static TextStyle textStyle(double fontSize, Color color,
          [FontWeight weight, Color bkgColor, double height, bool isUnderLine]) =>
      TextStyle(
        color: color,
        backgroundColor: (null != bkgColor) ? bkgColor : Colors.transparent,
        fontWeight: (null != weight) ? weight : FontWeight.w600,
        fontSize: fontSize / 7 * SizeConfig.textMultiplier,
        fontFamily: AppFronts.Bahij,
        height: (null != height)? height: 1.6,
        // decoration: TextDecoration.underline //(null != isUnderLine && isUnderLine)?TextDecoration.underline: TextDecoration.none,
      );
}
