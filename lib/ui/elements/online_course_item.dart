import 'dart:convert';

import 'package:adrus/shared/imports.dart';
import 'package:adrus/ui/riverpod/video_thumbnail_controller.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_constants.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class OnlineCourseItem extends StatelessWidget {
  final String videoUrl;
  final title;
  final bool hideTitle;
  final Function(String) onTap;
  final String blockType;
  final Function onDonwload;
  OnlineCourseItem(
      {this.videoUrl,
      this.onTap,
      this.title,
      this.hideTitle = false,
      this.blockType,
      this.onDonwload});
  //  {
  //   videoThumbnailProvider = FutureProvider(
  //       (ref) => VideoThumbnailController.getThumbnailFromVideo(videoUrl));
  // }
  // FutureProvider<String> videoThumbnailProvider;
  @override
  Widget build(BuildContext context) {
    final w = context.width;
    final h = context.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              "assets/images/M05S1_1_P01-1C.jpg",
              width: w,
              height: w * 0.5,
              fit: BoxFit.cover,
            )
                .mRadius(radius: BorderRadius.circular(25))
                .mPadding(all: w * 0.03),
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black26,
                  border: Border.all(color: Colors.white)),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: w * 0.1,
              ).mPadding(all: w * 0.03),
            )
          ],
        ).mTap(onTap: () => onTap(videoUrl)),
        if (!hideTitle)
          Text(
            title ?? "",
            textAlign: TextAlign.right,
            style: AppTextStyles.textStyle(
                13, Colors.white, FontWeight.w500, null, 2),
          ),
        if (blockType == AppConstants.MY_COURSES)
          InkWell(
            onTap: onDonwload,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Icon(
                Icons.download_rounded,
                color: AppColors.YELLOW_DARK,
              ),
              SizedBox(
                width: 1.5 * SizeConfig.widthMultiplier,
              ),
              Text(
                'تحميل الدرس',
                textAlign: TextAlign.right,
                style: AppTextStyles.textStyle(
                    11, AppColors.YELLOW_DARK, FontWeight.w600, null, 2),
              )
            ]),
          ),
        if (!hideTitle)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(
              color: AppColors.YELLOW_DARK,
            ),
          )
      ],
    );
  }
}
