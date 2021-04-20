import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:adrus/widgets/svg_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String title;
  final double titleSize;
  final Color titleColor;
  final String iconPath;
  final double iconSize;
  final Function onTap;
  final double width;
  final double height;
  final double margin;
  final bool fillWidth;
  final double paddingValue;
  final double marginHorizontal;
  final Color bkgColor;
  final bool showShadow;
  final BoxDecoration decoration;
  final int radius;
  final FontWeight fontWight;
  final TextAlign textAlign;
  final MainAxisAlignment mainAlignment;
  final CrossAxisAlignment crossAlignment;
  final bool isTextUnderLine;

  MyButton(
      {Key key,
      @required this.title,
      this.iconPath,
      this.iconSize,
      this.titleSize,
      this.titleColor,
      this.width,
      this.height,
      this.margin,
      this.fillWidth,
      this.paddingValue,
      this.marginHorizontal,
      this.bkgColor,
      this.showShadow,
      this.decoration,
      this.onTap,
      this.radius,
      this.fontWight,
      this.textAlign,
      this.mainAlignment,
      this.crossAlignment,
      this.isTextUnderLine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (null != width) ? width * SizeConfig.widthMultiplier : null,
      height: (null != height) ? height * SizeConfig.heightMultiplier : null,
      child: InkWell(
        onTap: () {
          this.onTap();
        },
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: (null != bkgColor) ? bkgColor : AppColors.PRIMARY,
            ),

            // decoration: (null != decoration)
            //     ? decoration
            //     : AppStyles.decorationRoundedColoredShadow(
            //         (null != bkgColor) ? bkgColor : AppColors.PRIMARY,
            //         (null != radius) ? radius * SizeConfig.heightMultiplier : 0,
            //         null,
            //         null,
            //         (null != showShadow && !showShadow) ? 0 : 5),
            padding: EdgeInsets.all((null != paddingValue)
                ? paddingValue * SizeConfig.heightMultiplier
                : 1.8 * SizeConfig.heightMultiplier),
            child: Row(
              mainAxisAlignment: (null != mainAlignment)
                  ? mainAlignment
                  : MainAxisAlignment.center,
              crossAxisAlignment: (null != crossAlignment)
                  ? crossAlignment
                  : CrossAxisAlignment.center,
              children: [
                (null != iconPath)
                    ? Image.asset(
                        iconPath,
                        color: Colors.white,
                        width: (null != iconSize)
                            ? iconSize
                            : 2.5 * SizeConfig.heightMultiplier,
                        height: (null != iconSize)
                            ? iconSize
                            : 2.5 * SizeConfig.heightMultiplier,
                      )
                    : Center(),
                (null != iconPath)
                    ? SizedBox(
                        width: 3 * SizeConfig.widthMultiplier,
                      )
                    : Center(),
                Text(
                  title,
                  textAlign: (null != textAlign) ? textAlign : TextAlign.center,
                  style: AppTextStyles.textStyle(
                      (null != titleSize) ? titleSize : 18,
                      (null != titleColor) ? titleColor : Colors.white,
                      (null != fontWight) ? fontWight : FontWeight.normal,
                      null,
                      null,
                      (null != isTextUnderLine) ? isTextUnderLine : false),
                ),
              ],
            )),
      ),
    );
  }
}
