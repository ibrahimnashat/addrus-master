import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowMoreItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        SizedBox(
          width: 1 * SizeConfig.heightMultiplier,
        ),
        Icon(
          Icons.arrow_back_ios,
          color: AppColors.YELLOW_DARK,
          size: 2.2 * SizeConfig.heightMultiplier,
        ),
        Text(
          "اسحب يساراً لرؤية المزيد",
          textAlign: TextAlign.right,
          style: AppTextStyles.textStyle(
            11,
            AppColors.YELLOW_DARK,
            FontWeight.w500,
          ),
        ),
      ]),
      SizedBox(
        height: 1 * SizeConfig.heightMultiplier,
      ),
    ]);
  }
}
