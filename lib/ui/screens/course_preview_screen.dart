import 'dart:convert';
import 'dart:io';
import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/class_data.dart';
import 'package:adrus/data/models/content_data.dart';
import 'package:adrus/data/models/course_data.dart';
import 'package:adrus/data/models/quiz.dart';
import 'package:adrus/data/models/responses/status_response.dart';
import 'package:adrus/di/injection_container.dart';
import 'package:adrus/shared/widgets/drag_widget.dart';
import 'package:adrus/ui/bloc/bloc_add_favorite.dart';
import 'package:adrus/ui/bloc/bloc_remove_favorite.dart';
import 'package:adrus/ui/elements/offline_video_widget.dart';
import 'package:adrus/ui/elements/online_course_item.dart';
import 'package:adrus/ui/elements/player_item.dart';
import 'package:adrus/ui/riverpod/download_file.dart';
import 'package:adrus/ui/riverpod/video_player_controller.dart';
import 'package:adrus/utils/app_utils.dart';
import 'package:adrus/utils/helpers/app_assets.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_constants.dart';
import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/message.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/session_manager.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:adrus/widgets/components.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_share/flutter_share.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'screen_quiz.dart';
import 'package:adrus/main.dart';

class CoursePreviewScreen extends StatefulWidget {
  final String blockType;
  final CourseData courseData;

  CoursePreviewScreen({
    @required this.blockType,
    @required this.courseData,
  });

  @override
  State<StatefulWidget> createState() {
    return ScreenState(courseData);
  }
}

ChangeNotifierProvider<DownloadFile> downloadFile =
    ChangeNotifierProvider((ref) => DownloadFile());

class ScreenState extends State<CoursePreviewScreen> {
  CourseData courseData;

  ScreenState(this.courseData);

  SessionManager sessionManager = sl<SessionManager>();
  final Components components = sl<Components>();
  final AddFavoriteBloc _addFavoriteBlock = sl<AddFavoriteBloc>();
  final RemoveFavoriteBloc _removeFavoriteBlock = sl<RemoveFavoriteBloc>();
  final AppUtils appUtils = sl<AppUtils>();
  bool isLoading = false;
  var paddingSmall = EdgeInsets.only(
    left: 5 * SizeConfig.heightMultiplier,
    right: 2 * SizeConfig.heightMultiplier,
    top: 0.0 * SizeConfig.heightMultiplier,
    bottom: 0.0 * SizeConfig.heightMultiplier,
  );
  var padding = EdgeInsets.only(
    left: 5 * SizeConfig.heightMultiplier,
    right: 2 * SizeConfig.heightMultiplier,
    top: 1.2 * SizeConfig.heightMultiplier,
    bottom: 1.2 * SizeConfig.heightMultiplier,
  );

  @override
  void initState() {
    _addFavoriteBlock.mainStream.listen(_observeAddFavorite);
    _removeFavoriteBlock.mainStream.listen(_observeRemoveFavorite);
    super.initState();
    print("Course overview_url: ${courseData.overview_url}");
    print("Course classes: ${courseData.classes}");
    videoPlayerController = AutoDisposeChangeNotifierProvider(
        (ref) => VideoPLayerController(widget.courseData.overview_url));
  }

  AutoDisposeChangeNotifierProvider<VideoPLayerController>
      videoPlayerController;

  @override
  void dispose() {
    _addFavoriteBlock.dispose();
    _removeFavoriteBlock.dispose();
    super.dispose();
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'تطبيق أُدرس',
        text: 'هيا لنتشارك معاً تطبيق أُدرس',
        linkUrl: 'https://adrus.ly',
        chooserTitle: "تطبيق أٌدرس");
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Consumer(builder: (context, watch, child) {
      final controller = watch(videoPlayerController);
      final download = watch(downloadFile);
      return Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        appBar: components.myAppBar(
          "",
          true,
          InkWell(
            onTap: share,
            child: Padding(
              padding: EdgeInsets.all(w * 0.05),
              child: Image.asset(
                AppAssets.IC_SHARE,
                width: 3 * SizeConfig.heightMultiplier,
                height: 3 * SizeConfig.heightMultiplier,
              ),
            ),
          ),
        ),
        body: Stack(
          children: [
            Builder(
                builder: (scaffoldContext) => Container(
                      color: AppColors.BLUE_MED,
                      margin: AppStyles.paddingSymmetric(0, 0),
                      padding: EdgeInsets.zero,
                      child: ListView(padding: EdgeInsets.all(0.0), children: <
                          Widget>[
                        (widget.blockType == AppConstants.MY_COURSES)
                            ? PlayerItem(
                                controller: controller.controller,
                              )
                            : OfflineVideoWidget(
                                isPromo: true,
                                videoId: "${widget.courseData.id}",
                                videoUrl: widget.courseData.overview_url,
                                blockType: widget.blockType,
                                videoDeleted: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          CoursePreviewScreen(
                                        courseData: widget.courseData,
                                        blockType: widget.blockType,
                                      ),
                                    ),
                                  );
                                },
                              ),
                        ListTile(
                          contentPadding: padding,
                          tileColor: AppColors.BLUE_DARK,
                          title: Text(
                            this.courseData.title ?? "",
                            textAlign: TextAlign.right,
                            style: AppTextStyles.textStyle(
                                18, Colors.white, FontWeight.w800),
                          ),
                          subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "${this.courseData.instructor.name ?? ""}",
                                  textAlign: TextAlign.right,
                                  style: AppTextStyles.textStyle(
                                      14, Colors.white, FontWeight.w600),
                                ),
                                SizedBox(
                                  width: 2 * SizeConfig.widthMultiplier,
                                ),
                                Text(
                                  ": بواسطة",
                                  textAlign: TextAlign.right,
                                  style: AppTextStyles.textStyle(
                                      14, Colors.white, FontWeight.w600),
                                ),
                              ]),
                        ),
                        (widget.blockType == AppConstants.MY_COURSES)
                            ? ListTile(
                                tileColor: Colors.white,
                                title: InkWell(
                                  onTap: () {
                                    if (widget.courseData.overview_url
                                        .contains("www.youtube.com")) {
                                      components.displayDialog(context, "",
                                          "لا يمكن تحميل هذا الفيديو");
                                    } else {
                                      if (!download.downloading) {
                                        setState(() {
                                          widget.courseData.videoDownloaded =
                                              true;
                                        });
                                        handleVideoDownload(
                                            widget.courseData.id.toString(),
                                            widget.courseData.overview_url ??
                                                "");
                                      } else {
                                        components.displayToast(
                                            context, "انتظر من فضلك");
                                      }
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "تحميل الفيديو البرومو",
                                        textAlign: TextAlign.right,
                                        style: AppTextStyles.textStyle(
                                            15,
                                            AppColors.YELLOW_DARK,
                                            FontWeight.w700,
                                            null,
                                            2),
                                      ),
                                      SizedBox(
                                        width: 1 * SizeConfig.widthMultiplier,
                                      ),
                                      Icon(
                                        Icons.download_rounded,
                                        color: AppColors.YELLOW_DARK,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Center(),
                        ListTile(
                          contentPadding: padding,
                          tileColor: AppColors.BLUE_DARK,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${this.courseData.total_enroll ?? ""}",
                                      textAlign: TextAlign.right,
                                      style: AppTextStyles.textStyle(
                                          14, Colors.white, FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: 4 * SizeConfig.widthMultiplier,
                                    ),
                                    Text(
                                      ":عدد الطلبة المشتركين",
                                      textAlign: TextAlign.right,
                                      style: AppTextStyles.textStyle(
                                          14, Colors.white, FontWeight.w600),
                                    ),
                                  ]),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${this.courseData.language ?? ""}",
                                      textAlign: TextAlign.right,
                                      style: AppTextStyles.textStyle(
                                          14, Colors.white, FontWeight.w600),
                                    ),
                                    SizedBox(
                                      width: 6 * SizeConfig.widthMultiplier,
                                    ),
                                    Text(
                                      ":لغة الكورس هى",
                                      textAlign: TextAlign.right,
                                      style: AppTextStyles.textStyle(
                                          14, Colors.white, FontWeight.w600),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                        ListTile(
                          contentPadding: padding,
                          title: Text(
                            "تصنيف الكورس",
                            textAlign: TextAlign.right,
                            style: AppTextStyles.textStyle(
                                14, Colors.white, FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${this.courseData.category.name ?? ""}",
                            textAlign: TextAlign.right,
                            style: AppTextStyles.textStyle(
                                14, Colors.white, FontWeight.normal),
                          ),
                        ),
                        ListTile(
                          contentPadding: padding,
                          title: Text(
                            "نبذة قصيرة",
                            textAlign: TextAlign.right,
                            style: AppTextStyles.textStyle(
                                14, Colors.white, FontWeight.bold),
                          ),
                          subtitle: components
                              .getHtmContent(this.courseData.short_description),
                        ),
                        ListTile(
                          contentPadding: padding,
                          title: Text(
                            "تفاصيل أكثر عن الكورس",
                            textAlign: TextAlign.right,
                            style: AppTextStyles.textStyle(
                                14, Colors.white, FontWeight.bold),
                          ),
                          subtitle: components
                              .getHtmContent(this.courseData.big_description),
                        ),
                        ListTile(
                          contentPadding: padding,
                          title: Text(
                            "متطلبات الكورس",
                            textAlign: TextAlign.right,
                            style: AppTextStyles.textStyle(
                                14, Colors.white, FontWeight.bold, null, 2),
                          ),
                          subtitle: Text(
                            "${appUtils.getStringListString(this.courseData.requirement ?? "")}",
                            textAlign: TextAlign.right,
                            style: AppTextStyles.textStyle(
                                14, Colors.white, FontWeight.normal),
                          ),
                        ),
                        ListTile(
                          contentPadding: padding,
                          title: Text(
                            "الإستفادة من الكورس",
                            textAlign: TextAlign.right,
                            style: AppTextStyles.textStyle(
                                14, Colors.white, FontWeight.bold, null, 2),
                          ),
                          subtitle: Text(
                            "${appUtils.getStringListString(this.courseData.outcome ?? "")}",
                            textAlign: TextAlign.right,
                            style: AppTextStyles.textStyle(
                                14, Colors.white, FontWeight.normal),
                          ),
                        ),
                        SizedBox(
                          height: 2 * SizeConfig.heightMultiplier,
                        ),
                        (null != this.courseData.classes &&
                                this.courseData.classes.isNotEmpty)
                            ? classesBlock(this.courseData.classes)
                            : Center(),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          contentPadding: padding,
                          tileColor: Colors.white,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppAssets.IC_ARROW_RIGHT,
                                color: Colors.black,
                                width: 2 * SizeConfig.heightMultiplier,
                                height: 2 * SizeConfig.heightMultiplier,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                " رؤية المزيد من الفيديوهات",
                                textAlign: TextAlign.center,
                                style: AppTextStyles.textStyle(
                                    14, Colors.black, FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      ]),
                    )),
            // (download.downloading)
            //     ? Positioned(
            //         top: 0,
            //         bottom: 0,
            //         right: 0,
            //         left: 0,
            //         child: Container(
            //           color: Colors.black45,
            //           child: Center(
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: <Widget>[
            //                 CircularProgressIndicator(),
            //                 SizedBox(
            //                   height: 20.0,
            //                 ),
            //                 Container(
            //                   padding: AppStyles.paddingSymmetric(6, 2),
            //                   decoration: AppStyles.decorationRoundedColored(
            //                       AppColors.GRAY_LIGHT, 24),
            //                   child: Text(
            //                     " ${download.progressString}  جارى تحميل الفيديو ",
            //                     style: AppTextStyles.textStyle(
            //                         14, Colors.orange, FontWeight.bold),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       )
            //     : Center()
          ],
        ),
      ).isDrag(
        (controller.showPopUp)
            ? Material(
                type: MaterialType.transparency,
                child: Stack(
                  children: [
                    Container(
                      width: w,
                      child: PlayerItem(
                        controller: controller.video,
                      ),
                    ),
                    PositionedDirectional(
                      end: 5,
                      top: 5,
                      child: InkWell(
                        onTap: () {
                          controller.exit();
                        },
                        child: Icon(
                          Icons.close,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox(),
        backgroundShow: controller.showPopUp,
        drag2: (download.downloading)
            ? Material(
                child: Consumer(builder: (context, watch, child) {
                  final download = watch(downloadFile);

                  return Container(
                    padding: AppStyles.paddingSymmetric(6, 2),
                    child: Text(
                      " ${download.progressString}  جارى تحميل الفيديو ",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.textStyle(
                          14, Colors.orange, FontWeight.bold),
                    ),
                  );
                }),
              )
            : null,
      );
    });
  }

  Widget classesBlock(List<ClassData> classes) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: classes.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                contentPadding: paddingSmall,
                tileColor: AppColors.YELLOW_DARK,
                title: Text(
                  classes[index].title ?? "",
                  textAlign: TextAlign.right,
                  style: AppTextStyles.textStyle(
                      14, Colors.white, FontWeight.bold, null, 2),
                ),
              ),
              (null != classes[index].videos &&
                      classes[index].videos.isNotEmpty)
                  ? ListTile(
                      contentPadding: paddingSmall,
                      tileColor: Colors.black,
                      title: Text(
                        "الدروس",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textStyle(
                            14, Colors.white, FontWeight.bold, null, 2),
                      ),
                    )
                  : Center(),
              (null != classes[index].videos &&
                      classes[index].videos.isNotEmpty)
                  ? classVideos(classes[index].videos, classes[index].id)
                  : Center(),
              (null != classes[index].documents &&
                      classes[index].documents.isNotEmpty)
                  ? ListTile(
                      contentPadding: paddingSmall,
                      title: Text(
                        "المرفقات",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textStyle(
                            14, Colors.white, FontWeight.bold, null, 2),
                      ),
                    )
                  : Center(),
              (null != classes[index].documents &&
                      classes[index].documents.isNotEmpty)
                  ? classDocuments(classes[index].documents)
                  : Center(),
              (null != classes[index].quizzes &&
                      classes[index].quizzes.isNotEmpty)
                  ? ListTile(
                      contentPadding: paddingSmall,
                      tileColor: AppColors.BLUE_DARK,
                      title: Text(
                        "الإختبارات",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textStyle(
                            14, Colors.white, FontWeight.bold, null, 2),
                      ),
                    )
                  : Center(),
              (null != classes[index].quizzes &&
                      classes[index].quizzes.isNotEmpty)
                  ? classQuizes(classes[index].quizzes)
                  : Center(),
            ],
          );
        });
  }

  Widget classQuizes(List<Quiz> quizes) {
    return Container(
      padding: AppStyles.paddingSymmetric(2, 2),
      color: AppColors.BLUE_DARK,
      child: Column(
          children: quizes
              .map((e) => InkWell(
                    onTap: () {
                      print("object mmmmmmmm");
                      AppUtils.checkConnectivity().then((isConnected) {
                        if (isConnected) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  QuizScreen(quiz: e)));
                        } else {
                          components.displayDialog(context, "",
                              "افحص اتصالك بالانترنت وحاول مرة اخرى");
                        }
                      });
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        e.quizz.name ?? "",
                        textAlign: TextAlign.right,
                        style: AppTextStyles.textStyle(
                            12, Colors.white, FontWeight.w500, null, 2),
                      ),
                      trailing: Icon(
                        Icons.article_outlined,
                        color: Colors.white,
                        size: 3 * SizeConfig.heightMultiplier,
                      ),
                      leading: Text(
                        "( ${e.quizz.date ?? ""} )",
                        textAlign: TextAlign.left,
                        style: AppTextStyles.textStyle(
                            12, Colors.white, FontWeight.w500, null, 2),
                      ),
                    ),
                  ))
              .toList()),
    );
  }

  Widget classDocuments(List<ContentData> documents) {
    return Container(
      padding: AppStyles.paddingSymmetric(2, 2),
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                AppUtils.checkConnectivity().then((isConnected) {
                  print("isConnected: $isConnected");
                  if (isConnected) {
                    launchURL(documents[index].url);
                  } else {
                    components.displayDialog(
                        context, "", "افحص اتصالك بالانترنت وحاول مرة اخرى");
                  }
                });
              },
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  documents[index].title ?? "",
                  textAlign: TextAlign.right,
                  style: AppTextStyles.textStyle(
                      12, Colors.white, FontWeight.w500, null, 2),
                ),
                trailing: Icon(
                  Icons.attach_file,
                  color: Colors.white,
                  size: 3 * SizeConfig.heightMultiplier,
                ),
              ),
            );
          }),
    );
  }

  Widget classVideos(List<ContentData> videos, int classId) {
    final download = context.read(downloadFile);
    return Container(
      margin: EdgeInsets.zero,
      color: Colors.black,
      padding: AppStyles.paddingSymmetric(1, 1),
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: videos.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                (widget.blockType == AppConstants.MY_COURSES)
                    ? OnlineCourseItem(
                        blockType: widget.blockType,
                        onDonwload: () {
                          if (widget.courseData.overview_url
                              .contains("www.youtube.com")) {
                            components.displayDialog(
                                context, "", "لا يمكن تحميل هذا الفيديو");
                          } else {
                            if (!download.downloading) {
                              setState(() {
                                videos[index].videoDownloaded = true;
                              });
                              handleVideoDownload(
                                  "${widget.courseData.id}-$classId-${videos[index].id}",
                                  videos[index].video_url);
                            } else {
                              components.displayToast(context, "انتظر من فضلك");
                            }
                          }
                        },
                        title: videos[index].title,
                        videoUrl: videos[index].video_url,
                        onTap: (url) {
                          final controller =
                              context.read(videoPlayerController);
                          controller.changeVideo(url);
                        },
                      )
                    : OfflineVideoWidget(
                        isPromo: false,
                        title: videos[index].title,
                        onTap: (url) {
                          print("hhhhhh" + url);
                          final controller =
                              context.read(videoPlayerController);
                          controller.changeVideo(url);
                        },
                        videoId:
                            "${widget.courseData.id}-$classId-${videos[index].id}",
                        videoUrl: videos[index].video_url,
                        blockType: widget.blockType,
                        videoDeleted: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CoursePreviewScreen(
                                courseData: widget.courseData,
                                blockType: widget.blockType,
                              ),
                            ),
                          );
                        },
                      ),
              ],
            );
          }),
    );
  }

  //MARK:----------

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget favoriteBtn() {
    return InkWell(
      onTap: () {
        print("is_favourited ${this.courseData.is_favourited}");

        if (this.courseData.is_favourited == 0) {
          _addFavoriteBlock.addFavorite(this.courseData.id);
        } else if (this.courseData.is_favourited == 1) {
          _removeFavoriteBlock.removeFavorite(this.courseData.id);
        }
      },
      child: Image.asset(
        AppAssets.IC_FAVORITE,
        width: 3 * SizeConfig.heightMultiplier,
        height: 3 * SizeConfig.heightMultiplier,
        color: (this.courseData.is_favourited == 0) ? Colors.white : null,
      ),
    );
  }

  void _observeAddFavorite(Result<StatusResponse> result) {
    print("Result Login:: $result");
    setState(() {
      isLoading = false;
    });
    if (result is SuccessResult) {
      this.courseData.is_favourited = 1;
      if (null != result.getSuccessData().message) {
        components.displayToast(context, result.getSuccessData().message);
      }
    } else if (result is ErrorResult) {
      StatusResponse error = StatusResponse.decodedJson(
          result.getErrorMessage().replaceAll("Exception:", ""));
      if (error.status == 401) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          sessionManager.deleteUser();
          Phoenix.rebirth(context);
        });
      } else {
        components.displayDialog(
            context, Message.ERROR_HAPPENED, result.getErrorMessage());
      }
    }
  }

  void _observeRemoveFavorite(Result<StatusResponse> result) {
    print("Result Login:: $result");
    setState(() {
      isLoading = false;
    });
    if (result is SuccessResult) {
      this.courseData.is_favourited = 0;

      if (null != result.getSuccessData().message) {
        components.displayToast(context, result.getSuccessData().message);
      }
    } else if (result is ErrorResult) {
      StatusResponse error = StatusResponse.decodedJson(
          result.getErrorMessage().replaceAll("Exception:", ""));
      if (error.status == 401) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          sessionManager.deleteUser();
          Phoenix.rebirth(context);
        });
      } else {
        components.displayDialog(
            context, Message.ERROR_HAPPENED, result.getErrorMessage());
      }
    }
  }

//  ---------
  void handleVideoDownload(String id, String url) {
    final download = context.read(downloadFile);
    appUtils.isVideoDownloaded(id, url).then((isDownloaded) {
      if (isDownloaded) {
        components.displayDialog(context, "", "تم تحميل هذا الفيديو من قبل");
      } else {
        download.downloadFile(id, url, courseData, context);
      }
    });
  }
}

// ListTile(
//     contentPadding: padding,
//     tileColor: AppColors.YELLOW_DARK,
//     title: Text(
//       (this.courseData.is_free == "1")
//           ? "هذا الكورس مجانى"
//           : "اشترى هذا الكورس بتكلفة ${this.courseData.discount_price} دينار ليبى",
//       textAlign: TextAlign.right,
//       style: AppTextStyles.textStyle(
//           14, Colors.white, FontWeight.bold),
//     )),
