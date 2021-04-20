import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/responses/my_courses_response.dart';
import 'package:adrus/data/models/responses/status_response.dart';
import 'package:adrus/di/injection_container.dart';
import 'package:adrus/shared/widgets/text.dart';
import 'package:adrus/ui/bloc/bloc_my_courses.dart';
import 'package:adrus/ui/elements/downloaded_videos.dart';
import 'package:adrus/ui/elements/my_drawer.dart';
import 'package:adrus/ui/elements/vertical_video_list.dart';
import 'package:adrus/ui/screens/course_preview_screen.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_constants.dart';
import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/session_manager.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:adrus/widgets/components.dart';
import 'package:adrus/widgets/loading_indicator.dart';
import 'package:adrus/widgets/my_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:adrus/main.dart';

import 'package:adrus/shared/widgets/drag_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoursesScreen extends StatefulWidget {
  final String title;
  final String icon;
  final String blockType;
  final Function returnedBack;

  CoursesScreen(
      {@required this.blockType,
      @required this.title,
      this.icon,
      @required this.returnedBack});

  @override
  State<StatefulWidget> createState() {
    return ScreenState();
  }
}

class ScreenState extends State<CoursesScreen> {
  SessionManager sessionManager = sl<SessionManager>();
  final Components components = sl<Components>();
  final MyCoursesBloc _myCoursesBloc = sl<MyCoursesBloc>();
  bool isLoading = false;

  @override
  void initState() {
    _myCoursesBloc.getMyCourses();
    super.initState();
  }

  @override
  void dispose() {
    // _myCoursesBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: components.myAppBar(""),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      endDrawer: Drawer(
        child: MyDrawer(
          currentPagIndex:
              ((widget.blockType == AppConstants.MY_COURSES) ? 3 : 4),
        ),
      ),
      body: Builder(
        builder: (scaffoldContext) => Stack(
          children: <Widget>[
            Container(
              height: 30 * SizeConfig.heightMultiplier,
              color: AppColors.YELLOW_DARK,
            ),
            (widget.blockType == AppConstants.MY_COURSES)
                ? myCoursesData()
                : DownloadedCourses(
                    listType: AppConstants.VERTICAL,
                    blockType: widget.blockType,
                    title: widget.title,
                    icon: widget.icon,
                  ),
            (isLoading)
                ? LoadingIndicator(
                    fullScreen: true,
                  )
                : Center(),
          ],
        ),
      ),
    ).isDrag(
      Material(
        child: Consumer(builder: (context, watch, child) {
          final download = watch(downloadFile);
          if (download.downloading)
            return Container(
              padding: AppStyles.paddingSymmetric(6, 2),
              child: Text(
                " ${download.progressString}  جارى تحميل الفيديو ",
                textAlign: TextAlign.center,
                style:
                    AppTextStyles.textStyle(14, Colors.orange, FontWeight.bold),
              ),
            );
          return SizedBox();
        }),
      ),
    );
  }

  Widget myCoursesData() {
    return StreamBuilder<Result<MyCoursesResponse>>(
        stream: _myCoursesBloc.mainStream,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            Result<MyCoursesResponse> result = snapshot.data;
            if (result is SuccessResult) {
              if (result.getSuccessData().data.isNotEmpty) {
                return VerticalVideoList(
                  data: result.getSuccessData().data,
                  blockType: widget.blockType,
                  title: widget.title,
                  icon: widget.icon,
                  returnedBack: () {
                    widget.returnedBack();
                  },
                );
              } else {
                return MyError("لا يوجد كورسات", Colors.white);
              }
            } else if (result is ErrorResult) {
              StatusResponse error = StatusResponse.decodedJson(
                  result.getErrorMessage().replaceAll("Exception:", ""));
              if (error.status == 401) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  sessionManager.deleteUser();
                  Phoenix.rebirth(context);
                });
                return Center();
              } else {
                if (result.getErrorMessage().contains("101")) {
                  return MyError("offline");
                }
                return MyError(result.getErrorMessage());
              }
            } else {
              return LoadingIndicator(
                indicatorSize: 3,
              );
            }
          } else {
            return LoadingIndicator(
              indicatorSize: 3,
            );
          }
        });
  }

//  ------

}
