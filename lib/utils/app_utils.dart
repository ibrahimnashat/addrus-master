import 'dart:convert';
import 'dart:io';
import 'package:adrus/data/models/course_data.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'helpers/app_constants.dart';

class AppUtils {
  static Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
    // try {
    //   final result = await InternetAddress.lookup('google.com');
    //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //     print("connected");
    //     return true;
    //   } else {
    //     print("not connected");
    //     return false;
    //   }
    // } on SocketException catch (_) {
    //   print("not connected");
    //   return false;
    // }
    // return false;
  }

//------

  bool isTable() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    print("data.size.shortestSide: ${data.size.shortestSide}");
    print("font sizes:: ${data.size.shortestSide < 600 ? false : true}");
    return data.size.shortestSide < 600 ? false : true;
  }

  removeBrackets(String content) {
    String text = content
        .replaceAll("}", " ")
        .replaceAll("{", " ")
        .replaceAll("[", " ")
        .replaceAll("]", " ")
        .replaceAll('"', "")
        .replaceAll("Exception:", "")
        .replaceAll("error:", "")
        .replaceAll("message:", "");
    print("removeBrackets: $text");
    return text;
  }

//  --------------

  getStringListString(List<String> content) {
    print("getStringListString: $content");
    var txt = '';
    for (String item in content) {
      print("ITEM#: $item");
      if(item != "") {
        txt = txt + "$item" + "  - " + "\n";
      }
    }

    return txt;
  }

//  ----------video-----

  Future<String> getFileContent(String fileName) async {
    try {
      final file = await getLocalFile(fileName);
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return '';
    }
  }

  Future<File> getLocalFile(String fileName) async {
    final path = await getLocalPath();
    return File('$path/$fileName');
  }

  Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    print("directory.path:: ${directory.path}");
    return "${directory.path}/addrus/";
  }

  Future<File> writeContent(String fileName, String content) async {
    final file = await getLocalFile(fileName);
    // Write the file
    return file.writeAsString(content);
  }

  Future<List<CourseData>> getDownloadedVideosContent() async {
    String videosData =
        await getFileContent(AppConstants.DOWNLOADED_COURSES_CONTENT);
    print("File - ${videosData.isNotEmpty}::: ${videosData}");
    if (videosData.isNotEmpty) {
      print("json.decode(videosData): ${json.decode(videosData)}");
      List<CourseData> videosList = (json.decode(videosData) as List)
          .map((i) => CourseData.fromJson(i))
          .toList();
      print("videosList:: $videosList");
      return videosList;
    } else {
      return [];
    }
  }

  Future<List<String>> getDownloadedVideosNames() async {
    String videosData = await getFileContent(AppConstants.DOWNLOADED_VIDEOS_NAMES);
    print("DownloadedVideos - ${videosData.isNotEmpty}::: ${videosData}");
    if (videosData.isNotEmpty) {
      print("json.decode(videosData): ${json.decode(videosData)}");
      List<String> videosList =
          (json.decode(videosData) as List).cast<String>();

      print("videosList:: $videosList");
      return videosList;
    } else {
      return [];
    }
  }

  Future<bool> isDownloaded(String id, String url) async {
    final file = await getLocalFile(getVideoName(id, url));
    return file.exists();
  }

  Future<bool> isVideoDownloaded(String id, String url) async {
    String videoName = getVideoName(id, url);
    List<String> downloadedVideosNameList = await getDownloadedVideosNames();
    print("Video name: ${id}");
    print("downloadedVideosName: ${downloadedVideosNameList}");
    List<String> filterVideos =
        downloadedVideosNameList.where((i) => i == videoName).toList();

    bool downloaded = await isDownloaded(id, url);
    print("Check: ${filterVideos} && ${downloaded}");

    if (filterVideos.isNotEmpty && downloaded) {
      print("Check 1");
      return true;
    } else if ((filterVideos.isEmpty && downloaded) ){
      print("Check 2");
      deleteVideo(id, url);
      return false;
    } else if (filterVideos.isNotEmpty && !downloaded) {
      print("Check 3");
      downloadedVideosNameList.remove(videoName);
      writeContent(
          AppConstants.DOWNLOADED_VIDEOS_NAMES, json.encode(downloadedVideosNameList));
      return false;
    } else {
      print("Check 4");
      return false;
    }
  }

  Future<void> deleteVideo(String id, String url) async {
    final file = await getLocalFile(getVideoName(id, url));
    file.delete();
  }

  String getVideoName(String id, String url) {
    var fileExtension = url.split(".").last;
    print("fileExtension: ${fileExtension}");
    return "${id}.${fileExtension}";
  }
}
