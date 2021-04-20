
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  final String path;
  final Color color;
  final double padding;
  final double width;
  final double height;
  final BoxDecoration decoration;

  SvgIcon(
      {Key key,
      @required this.path,
      this.color,
      this.padding,
      this.width,
      this.height,
      this.decoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: (null != decoration) ? decoration : null,
      padding: EdgeInsets.all(
          (null != padding) ? padding * SizeConfig.heightMultiplier : 0),
      child: SvgPicture.asset(
        path,
        color: (null != color) ? color : AppColors.GRAY_LIGHT,
        fit: BoxFit.fill,
        alignment: Alignment.centerRight,
        width: (null != width) ? width * SizeConfig.heightMultiplier : 1 * SizeConfig.heightMultiplier,
        height: (null != height) ? height * SizeConfig.heightMultiplier : 1 * SizeConfig.heightMultiplier,
      ),
    );
  }
}
