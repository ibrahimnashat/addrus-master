import 'dart:convert';
import 'dart:io';

import 'package:adrus/data/models/course_data.dart';
import 'package:adrus/di/injection_container.dart';
import 'package:adrus/utils/app_utils.dart';
import 'package:adrus/utils/helpers/app_constants.dart';
import 'package:adrus/widgets/components.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DownloadFile extends ChangeNotifier {
  final Components components = sl<Components>();
  bool downloading = false;
  var progressString = "...";
  final AppUtils appUtils = sl<AppUtils>();
  Future<void> downloadFile(String id, String url, CourseData courseData,
      BuildContext context) async {
    Dio dio = Dio();
    String videoUrl = url;
    String videoName = appUtils.getVideoName(id, url);
    var videoPath = "${await appUtils.getLocalPath()}/$videoName";

    try {
      await dio.download(videoUrl, videoPath,
          options: Options(headers: {HttpHeaders.acceptEncodingHeader: "*"}),
          onReceiveProgress: (count, total) {
        downloading = true;
        notifyListeners();
        var percentage = (count / total);
        print("percentage: $percentage");
        if (total != -1) {
          progressString = (percentage * 100).toStringAsFixed(0) + "%";
        } else {
          percentage = percentage * -1;
          progressString = (percentage).toStringAsFixed(2) + "%";
        }
      });
    } catch (e) {
      print(e);
    }

    appUtils.getDownloadedVideosContent().then((value) {
      List<CourseData> downloadedVideosList = value;

      List<CourseData> oldDownloadVideos =
          downloadedVideosList.where((i) => i.id == courseData.id).toList();
      if (oldDownloadVideos.isNotEmpty) {
        //this course not downloaded before
        downloadedVideosList.remove(oldDownloadVideos[0]);
      }
      downloadedVideosList.add(courseData);
      appUtils.writeContent(AppConstants.DOWNLOADED_COURSES_CONTENT,
          json.encode(downloadedVideosList));

      downloading = false;
      progressString = "تم التحميل ";

      components.displayToast(context, "تم تحميل الفيديو بنجاح");
      notifyListeners();
      appUtils.getDownloadedVideosNames().then((value) {
        List<String> videosNameList = value;
        List<String> videoNameSaved =
            videosNameList.where((i) => i == videoName).toList();
        if (videoNameSaved.isNotEmpty) {
          //this course not downloaded before
          videosNameList.remove(videoNameSaved[0]);
        }
        videosNameList.add(videoName);
        print("VIDEO_NAME_SAVED        2");
        appUtils.writeContent(
            AppConstants.DOWNLOADED_VIDEOS_NAMES, json.encode(videosNameList));
        print("VIDEO_NAME_SAVED");
      });
    });
  }
}
