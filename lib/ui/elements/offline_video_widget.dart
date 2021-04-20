import 'package:adrus/di/injection_container.dart';
import 'package:adrus/ui/elements/online_course_item.dart';
import 'package:adrus/ui/elements/player_item.dart';
import 'package:adrus/ui/riverpod/video_player_controller.dart';
import 'package:adrus/utils/app_utils.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OfflineVideoWidget extends StatefulWidget {
  final String blockType;
  final String videoUrl;
  final String videoId;
  final bool isPromo;
  final Function videoDeleted;
  final Function(String) onTap;
  final title;
  OfflineVideoWidget(
      {@required this.blockType,
      @required this.videoUrl,
      @required this.videoId,
      this.isPromo = false,
      this.title,
      @required this.videoDeleted,
      this.onTap});

  @override
  State<StatefulWidget> createState() {
    return ScreenState();
  }
}

class ScreenState extends State<OfflineVideoWidget> {
  final AppUtils appUtils = sl<AppUtils>();
  bool notFound = false;
  bool checkFinished = false;
  String path;

  AutoDisposeChangeNotifierProvider<VideoPLayerController>
      videoPlayerController;
  @override
  Widget build(BuildContext context) {
    appUtils
        .isVideoDownloaded(widget.videoId, widget.videoUrl)
        .then((isDownloaded) {
      if (isDownloaded) {
        appUtils.getLocalPath().then((localPath) {
          String videoName =
              appUtils.getVideoName(widget.videoId, widget.videoUrl);

          path = "$localPath$videoName";
          if (widget.isPromo)
            videoPlayerController = AutoDisposeChangeNotifierProvider(
                (ref) => VideoPLayerController(path));
        });
      } else {
        setState(() {
          notFound = true;
        });
      }
      setState(() {
        checkFinished = true;
      });
    });
    if (path == null) return SizedBox(height: 0);
    return Container(
        color: Colors.black,
        padding: EdgeInsets.only(bottom: 2 * SizeConfig.heightMultiplier),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            (null != path)
                ? videoPlayerController != null
                    ? Consumer(builder: (context, watch, child) {
                        final controller = watch(videoPlayerController);
                        return PlayerItem(
                          controller: controller.controller,
                        );
                      })
                    : OnlineCourseItem(
                        hideTitle: true,
                        videoUrl: widget.videoUrl,
                        onTap: (url) {
                          print("hhhhhh" + path);
                          widget.onTap(path);
                        },
                      )
                : SizedBox(),
            if (!widget.isPromo)
              Text(
                widget.title ?? "",
                textAlign: TextAlign.right,
                style: AppTextStyles.textStyle(
                    13, Colors.white, FontWeight.w500, null, 2),
              ),
            (!notFound && checkFinished)
                ? InkWell(
                    onTap: () {
                      appUtils
                          .deleteVideo(widget.videoId, widget.videoUrl)
                          .then((value) {
                        widget.videoDeleted();
                      });
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.restore_from_trash,
                            color: AppColors.RED_GOOGLE,
                          ),
                          SizedBox(
                            width: 1.5 * SizeConfig.widthMultiplier,
                          ),
                          Text(
                            'حذف الفيديو',
                            textAlign: TextAlign.right,
                            style: AppTextStyles.textStyle(11,
                                AppColors.RED_GOOGLE, FontWeight.w600, null, 2),
                          )
                        ]),
                  )
                : Center(),
            if (!widget.isPromo)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(
                  color: AppColors.YELLOW_DARK,
                ),
              ),
          ],
        ));
  }
}
