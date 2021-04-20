import 'dart:convert';

import 'package:adrus/data/models/course_data.dart';
import 'package:adrus/data/models/responses/course_data_response.dart';
import 'package:adrus/di/injection_container.dart';
import 'package:adrus/ui/screens/course_preview_screen.dart';
import 'package:adrus/utils/api_utils.dart';
import 'package:adrus/utils/app_utils.dart';
import 'package:adrus/utils/helpers/app_assets.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_constants.dart';
import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:adrus/widgets/components.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:adrus/main.dart';

class VerticalVideoList extends StatefulWidget {
  final List<CourseData> data;
  final String title;
  final String icon;
  final String blockType;
  final Function returnedBack;
  final Function(CourseData) removeVideo;

  VerticalVideoList(
      {@required this.data,
      @required this.blockType,
      @required this.title,
      this.icon,
      @required this.returnedBack,
      this.removeVideo});

  @override
  State<StatefulWidget> createState() {
    return _ScreenState();
  }
}

class _ScreenState extends State<VerticalVideoList> {
  AppUtils appUtils = sl<AppUtils>();
  Components components = sl<Components>();
  bool downloading = false;
  var progressString = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.BLUE_DARK,
      padding: AppStyles.paddingAll(1, 2, 1, 2),
      margin: AppStyles.paddingSymmetric(2, 2),
      child: Column(
        children: [
          ListTile(
            trailing: Image.asset(
              widget.icon,
              color: Colors.white,
              width: 4 * SizeConfig.heightMultiplier,
              height: 4 * SizeConfig.heightMultiplier,
            ),
            title: Text(
              widget.title,
              textAlign: TextAlign.right,
              style: AppTextStyles.textStyle(16, Colors.white, FontWeight.bold),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: widget.data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                          onTap: () {
                            print("Course data: ${widget.data[index]}");
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        CoursePreviewScreen(
                                      courseData: widget.data[index],
                                      blockType: widget.blockType,
                                    ),
                                  ),
                                )
                                .then((value) => widget.returnedBack());
                          },
                          child: Container(
                            // width: 10 * SizeConfig.heightMultiplier,
                            height: 12 * SizeConfig.heightMultiplier,
                            margin: AppStyles.paddingAll(0.7, 0.7, 1, 0.7),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ListView(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      padding:
                                          AppStyles.paddingSymmetric(1, 1.2),
                                      children: [
                                        (widget.blockType ==
                                                AppConstants.OFFLINE_COURSES)
                                            ? InkWell(
                                                onTap: () {
                                                  widget.removeVideo(
                                                      widget.data[index]);
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.restore_from_trash,
                                                      color:
                                                          AppColors.RED_GOOGLE,
                                                    ),
                                                    SizedBox(
                                                      width: 1 *
                                                          SizeConfig
                                                              .widthMultiplier,
                                                    ),
                                                    Text(
                                                      "حذف",
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: AppTextStyles
                                                          .textStyle(
                                                              12,
                                                              AppColors
                                                                  .RED_GOOGLE,
                                                              FontWeight.w700,
                                                              null,
                                                              2),
                                                    ),
                                                  ],
                                                ))
                                            : Center(),
                                        Text(
                                          widget.data[index].title ?? "",
                                          textAlign: TextAlign.right,
                                          style: AppTextStyles.textStyle(13,
                                              Colors.white, FontWeight.w600),
                                        )
                                      ]),
                                ),
                                Container(
                                  decoration:
                                      AppStyles.decorationRoundedColored(
                                          Colors.black12, 0.5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          0.5 * SizeConfig.heightMultiplier),
                                    ),
                                    child: Image.network(
                                      widget.data[index].image ?? "",
                                      fit: BoxFit.contain,
                                      width: 34 * SizeConfig.widthMultiplier,
                                      height: double.infinity,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ));
                    }),
                (downloading)
                    ? Positioned.fill(
                        child: Container(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircularProgressIndicator(),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Container(
                                  padding: AppStyles.paddingSymmetric(6, 2),
                                  decoration:
                                      AppStyles.decorationRoundedColored(
                                          AppColors.GRAY_LIGHT, 24),
                                  child: Text(
                                    "$progressString" + " : تحميل الفيديو ",
                                    style: AppTextStyles.textStyle(
                                        14, Colors.orange, FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Center()
              ],
            ),
          )
        ],
      ),
    );
  }

  // void handleVideoDownload(CourseData data) {
  //   appUtils.isVideoDownloadedBefore(data.id).then((isDownloaded) {
  //     if (isDownloaded) {
  //       components.displayDialog(context, "", "تم تحميل هذا الفيديو من قبل");
  //     } else {
  //       downloadFile(data);
  //     }
  //   });
  // }
  //
  // Future<void> downloadFile(CourseData data) async {
  //   Dio dio = Dio();
  //
  //   String videoUrl = data.overview_url;
  //   String videoName = appUtils.getVideoName(data.id, data.overview_url);
  //   print("videoName: ${videoName}");
  //   var videoPath = "${await appUtils.getLocalPath()}/video$videoName"; //
  //   print("videoPath down: $videoPath");
  //
  //   try {
  //     await dio.download(videoUrl, videoPath, onReceiveProgress: (rec, total) {
  //       print("Rec: $rec , Total: $total");
  //
  //       setState(() {
  //         downloading = true;
  //         progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
  //       });
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  //
  //   setState(() {
  //     appUtils.getDownloadedVideosContent().then((value) {
  //       print("old data list: ${value}");
  //       List<CourseData> videosList = value;
  //       videosList.add(data);
  //       print("encoded list: ${json.encode(videosList.toSet().toList())}");
  //
  //       appUtils.writeContent(
  //           AppConstants.DOWNLOADED_COURSES_CONTENT, json.encode(videosList));
  //
  //       setState(() {
  //         downloading = false;
  //         progressString = "تم التحميل ";
  //       });
  //       components.displayToast(context, "تم تحميل الفيديو بنجاح");
  //     });
  //   });
  //   print("Download completed");
  // }
}

// (widget.blockType ==
//         AppConstants.MY_COURSES)
//     ? InkWell(
//         onTap: () {
//           if (widget
//               .data[index].overview_url
//               .contains(
//                   "www.youtube.com")) {
//             components.displayDialog(
//                 context,
//                 "",
//                 "لا يمكن تحميل هذا الفيديو");
//           } else {
//             if (!downloading) {
//               handleVideoDownload(
//                   widget.data[index]);
//             } else {
//               components.displayToast(
//                   context,
//                   "انتظر من فضلك");
//             }
//           }
//         },
//         child: Row(
//           mainAxisAlignment:
//               MainAxisAlignment.end,
//           children: [
//             Text(
//               "تحميل الكورس",
//               textAlign:
//                   TextAlign.right,
//               style: AppTextStyles
//                   .textStyle(
//                       15,
//                       AppColors
//                           .YELLOW_DARK,
//                       FontWeight.w700,
//                       null,
//                       2),
//             ),
//             SizedBox(
//               width: 1 *
//                   SizeConfig
//                       .widthMultiplier,
//             ),
//             Icon(
//               Icons.download_rounded,
//               color:
//                   AppColors.YELLOW_DARK,
//             ),
//           ],
//         ),
//       )
//     : Center(),
