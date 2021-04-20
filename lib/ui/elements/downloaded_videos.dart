import 'dart:convert';

import 'package:adrus/data/models/course_data.dart';
import 'package:adrus/data/models/responses/course_data_response.dart';
import 'package:adrus/di/injection_container.dart';
import 'package:adrus/main.dart';
import 'package:adrus/ui/elements/horizontal_vodeo_list.dart';
import 'package:adrus/ui/elements/show_more_items.dart';
import 'package:adrus/ui/elements/vertical_video_list.dart';
import 'package:adrus/utils/app_utils.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_constants.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/helpers/user_constants.dart';
import 'package:adrus/utils/session_manager.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:adrus/widgets/my_error.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class DownloadedCourses extends StatefulWidget {
  final String listType;
  final String title;
  final String icon;
  final String blockType;

  DownloadedCourses({
    @required this.listType,
    @required this.blockType,
    @required this.title,
    this.icon,
  });

  @override
  State<StatefulWidget> createState() {
    return _ScreenState();
  }
}

class _ScreenState extends State<DownloadedCourses> {
  AppUtils appUtils = sl<AppUtils>();
  SessionManager sessionManager = sl<SessionManager>();
  int cellCount = 2;

  @override
  void initState() {
    super.initState();
    if (appUtils.isTable()) {
      setState(() {
        cellCount = 3;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("DownloadedCourses");
    return VisibilityDetector(
      key: Key('my-widget-key'),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        debugPrint(
            'Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');
        try {
          setState(() {});
        } catch (e) {}
        downloadedCourses();
      },
      child: FutureBuilder<Widget>(
          future: downloadedCourses(),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.hasData) return snapshot.data;
            return Container(
                child: Center(
              child: CircularProgressIndicator(),
            ));
          }),
    );
  }

  Future<Widget> downloadedCourses() async {
    print("downloadedCourses");
    List<CourseData> videosList = await appUtils.getDownloadedVideosContent();
    print("Downloaded videos: ${videosList.toSet().toList()}");

    if (videosList.isNotEmpty) {
      sessionManager.setValue(
          UserConstants.DOWNLOADED_COURSES, "${videosList.length}");

      return (widget.listType == AppConstants.HORIZONTAL)
          ? Column(
              children: [
                (videosList.toSet().toList().length > 0)
                    ? ShowMoreItems()
                    : Center(),
                HorizontalVideoList(
                  data: videosList.toSet().toList(),
                  blockType: AppConstants.OFFLINE_COURSES,
                  returnedBack: () {
                    print("downloadedCourses back 1");
                    setState(() {
                      downloadedCourses();
                    });
                  },
                )
              ],
            )
          : VerticalVideoList(
              data: videosList.toSet().toList(),
              blockType: widget.blockType,
              title: widget.title ?? "",
              icon: widget.icon,
              removeVideo: (CourseData course) {
                setState(() {
                  appUtils.getDownloadedVideosNames().then((value) {
                    print("old data list: ${course.id} - ${value}");
                    List<String> downloadedVideosNamesList = value;
                    String videoName = appUtils.getVideoName(
                        course.id.toString(), course.overview_url);
                    downloadedVideosNamesList.remove(videoName);
                    appUtils
                        .deleteVideo("${course.id}", course.overview_url)
                        .then((value) {
                      print("Inner 1");
                      if (null != course.classes && course.classes.isNotEmpty) {
                        print("Inner 2");
                        for (var _class in course.classes) {
                          print("Inner 3");
                          if (null != _class.videos &&
                              _class.videos.isNotEmpty) {
                            for (var video in _class.videos) {
                              print("Inner video: ${video}");
                              String _videoName = appUtils.getVideoName(
                                  "${course.id}-${_class.id}-${video.id}",
                                  video.video_url);
                              downloadedVideosNamesList.remove(_videoName);
                              appUtils.deleteVideo(
                                  "${course.id}-${_class.id}-${video.id}",
                                  video.video_url);
                            }
                          }
                        }
                      }
                    });
                    print("After delete: ${downloadedVideosNamesList}");
                    appUtils.writeContent(AppConstants.DOWNLOADED_VIDEOS_NAMES,
                        json.encode(downloadedVideosNamesList));
                  });

                  // downloadedCourses();
                });

                videosList.remove(course);
                appUtils.writeContent(AppConstants.DOWNLOADED_COURSES_CONTENT,
                    json.encode(videosList));
              },
              returnedBack: () {
                print("downloadedCourses back 2");
                setState(() {
                  downloadedCourses();
                });
              },
            );
    } else {
      sessionManager.setValue(UserConstants.DOWNLOADED_COURSES, "0");
      print("no videosData");
      return MyError("لا يوجد كورسات محملة", Colors.white);
    }
  }
}
