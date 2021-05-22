import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/course_data.dart';
import 'package:adrus/data/models/responses/my_courses_response.dart';
import 'package:adrus/data/models/responses/status_response.dart';
import 'package:adrus/di/injection_container.dart';
import 'package:adrus/ui/bloc/bloc_my_courses.dart';
import 'package:adrus/ui/elements/downloaded_videos.dart';
import 'package:adrus/ui/elements/horizontal_vodeo_list.dart';
import 'package:adrus/ui/elements/show_more_items.dart';
import 'package:adrus/ui/screens/courses_screen.dart';
import 'package:adrus/utils/app_utils.dart';
import 'package:adrus/utils/helpers/app_constants.dart';
import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/message.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/helpers/user_constants.dart';
import 'package:adrus/utils/session_manager.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:adrus/widgets/components.dart';
import 'package:adrus/widgets/my_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:adrus/main.dart';

class HomeBlock extends StatefulWidget {
  final String title;
  final String icon;
  final Color color;
  final String blockType;
  final Function returnedBack;

  HomeBlock(
      {@required this.title,
      @required this.icon,
      this.color,
      @required this.blockType,
      @required this.returnedBack});

  @override
  State<StatefulWidget> createState() {
    return _ScreenState();
  }
}

class _ScreenState extends State<HomeBlock> {
  final MyCoursesBloc _myCoursesBloc = sl<MyCoursesBloc>();
  SessionManager sessionManager = sl<SessionManager>();
  final Components components = sl<Components>();
  AppUtils appUtils = sl<AppUtils>();

  bool isLoading = false;
  List<CourseData> myCoursesList = [];
  List<CourseData> videosList = [];

  @override
  void dispose() {
    // _myCoursesBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    print("HomeBlock");
    _myCoursesBloc.mainStream.listen(_observeMyCourses);
    _myCoursesBloc.getMyCourses();
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
        builder: (context) => SizedBox(),
        connectivityBuilder: (BuildContext context,
            ConnectivityResult connectivity, Widget child) {
          final bool connected = connectivity != ConnectivityResult.none;

          return Container(
            color: widget.color,
            child: Column(
                // shrinkWrap: true,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 1 * SizeConfig.heightMultiplier,
                        horizontal: 1.5 * SizeConfig.heightMultiplier),
                    onTap: () {
                      if (connected) {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => CoursesScreen(
                              blockType: widget.blockType,
                              title: widget.title,
                              icon: widget.icon,
                              returnedBack: () {
                                setState(() {});
                              },
                            ),
                          ),
                        )
                            .then((value) {
                          print("home block back 2");

                          widget.returnedBack();
                        });
                      } else {
                        components.displayDialog(
                            context, "", "برجاء الاتصال بالانترنت");
                      }
                    },
                    trailing: Image.asset(
                      widget.icon,
                      color: Colors.white,
                      width: 4 * SizeConfig.heightMultiplier,
                      height: 4 * SizeConfig.heightMultiplier,
                    ),
                    title: Text(
                      widget.title ?? "",
                      textAlign: TextAlign.right,
                      style: AppTextStyles.textStyle(
                          16, Colors.white, FontWeight.bold),
                    ),
                    leading: Container(
                      decoration:
                          AppStyles.decorationBottomBorder(Colors.white, 1),
                      child: Text(
                        "رؤية الكل",
                        style: AppTextStyles.textStyle(
                            14, Colors.white, FontWeight.w500),
                      ),
                    ),
                  ),
                  (myCoursesList.length > 0 &&
                          widget.blockType == AppConstants.MY_COURSES)
                      ? ShowMoreItems()
                      : Center(),
                  (widget.blockType == AppConstants.MY_COURSES)
                      ? (myCoursesList.isNotEmpty)
                          ? HorizontalVideoList(
                              data:
                                  myCoursesList, //tempList, //result.getSuccessData().data,
                              blockType: widget.blockType,
                              returnedBack: () {
                                print("home block back 1");
                                setState(() {});
                                _myCoursesBloc.getMyCourses();
                              },
                            )
                          : MyError("لا يوجد كورسات", Colors.white)
                      : DownloadedCourses(
                          listType: AppConstants.HORIZONTAL,
                          blockType: widget.blockType,
                          title: widget.title,
                          icon: widget.icon,
                        ),
                ]),
          );
        });
  }

  //--------

  //-------
  void _observeMyCourses(Result<MyCoursesResponse> result) {
    debugPrint("MyCourses:: ${result.getSuccessData()}");
    setState(() {
      isLoading = false;
    });
    if (result is SuccessResult) {
      saveCoursesData(result.getSuccessData().data);
      setState(() {
        myCoursesList = result.getSuccessData().data;
      });
    } else if (result is ErrorResult) {
      StatusResponse error = StatusResponse.decodedJson(
          result.getErrorMessage().replaceAll("Exception:", ""));
      if (error.status == 401) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          sessionManager.deleteUser();
          Phoenix.rebirth(context);
        });
      } else {
        if (result.getErrorMessage().contains("101")) {
          //offline
          components.displayDialog(context, "", "Offline");
        } else {
          components.displayDialog(
              context, Message.ERROR_HAPPENED, result.getErrorMessage());
        }
      }
    }
  }

  //--------

  //--------
  void saveCoursesData(List<CourseData> data) {
    int cost = 0;
    for (var item in data) {
      if ("${item.is_free}" == "0") {
        //paid
        if ("${item.is_discount}" == "1") {
          //have discount
          cost = cost + (item.price) - (int.parse("${item.discount_price}"));
        } else if ("${item.is_discount}" == "0") {
          cost = cost + (item.price);
        }
      }
    }
    sessionManager.setValue(UserConstants.COURSES_COST, "$cost");
    sessionManager.setValue(UserConstants.JOINED_COURSES, "${data.length}");
    print("cost saved: $cost");
  }
}
