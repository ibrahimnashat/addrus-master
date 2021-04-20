import 'dart:convert';

import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/responses/status_response.dart';
import 'package:adrus/di/injection_container.dart';
import 'package:adrus/ui/bloc/bloc_add_favorite.dart';
import 'package:adrus/ui/bloc/bloc_logout.dart';
import 'package:adrus/ui/screens/courses_screen.dart';
import 'package:adrus/ui/screens/edit_profile_screen.dart';
import 'package:adrus/ui/screens/home_screen.dart';
import 'package:adrus/ui/screens/profile_screen.dart';
import 'package:adrus/ui/screens/support_screen.dart';
import 'package:adrus/utils/app_utils.dart';
import 'package:adrus/utils/helpers/app_assets.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_constants.dart';
import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/helpers/user_constants.dart';
import 'package:adrus/utils/session_manager.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:adrus/widgets/components.dart';
import 'package:adrus/widgets/svg_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:adrus/main.dart';

class MyDrawer extends StatefulWidget {
  final int currentPagIndex;

  MyDrawer({@required this.currentPagIndex});

  @override
  State<StatefulWidget> createState() {
    return ScreenState();
  }
}

List<String> titles = [
  'للتعليم الإلكتروني' + '\n' + 'ADDRUS E-LEARNING',
  'الرئيسية',
  'الرئيسية',
  'الملف الشخصى',
  'دروسي',
  'الدروس المحملة',
  'الدعم الفنى',
  'تسجيل الخروج'
];
List<String> icons = [
  AppAssets.LOGO_WHITE,
  AppAssets.IC_HOME,
  AppAssets.IC_HOME,
  AppAssets.IC_PROFILE,
  AppAssets.IC_MY_COURSES,
  AppAssets.IC_OFFLINE_COURSES,
  AppAssets.IC_SUPPORT,
  AppAssets.IC_LOGOUT,
  AppAssets.LOGO_WHITE,
];

class ScreenState extends State<MyDrawer> {
  SessionManager sessionManager = sl<SessionManager>();
  final Components components = sl<Components>();
  final LogoutBloc _logoutBloc = sl<LogoutBloc>();
  final AppUtils appUtils = sl<AppUtils>();
  bool isLoading = false;

  @override
  void initState() {
    _logoutBloc.mainStream.listen(_observeLogout);

    super.initState();

    print("sessionManager.getUser().image: ${sessionManager.getUser().image}");
  }

  @override
  void dispose() {
    _logoutBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300 * SizeConfig.heightMultiplier,
      child: Drawer(
        child: Container(
          // color: Colors.blue,
          decoration: AppStyles.gradientBlueDarkDecoration(),
          child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemCount: titles.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: (index == 1)
                      ? AppStyles.decorationBottomBorder(Colors.white38, 0.5)
                      : null,
                  child: ListTile(
                    tileColor: (index == (widget.currentPagIndex + 1))
                        ? AppColors.YELLOW_DARK
                        : (index == 0)
                            ? AppColors.BLUE_DARK2
                            : Colors.transparent,
                    contentPadding: EdgeInsets.fromLTRB(
                        1 * SizeConfig.heightMultiplier,
                        ((index == 0) ? 7 : 1) * SizeConfig.heightMultiplier,
                        2 * SizeConfig.heightMultiplier,
                        ((index == 0) ? 7 : 1) * SizeConfig.heightMultiplier),
                    title: Text(
                      (index == 1)
                          ? sessionManager.getUser().name
                          : titles[index],
                      textAlign: TextAlign.right,
                      style: index == 0
                          ? AppTextStyles.textStyle(16, Colors.white,
                              FontWeight.w600, null, (index == 0) ? 2 : 1.3)
                          : AppTextStyles.textStyle(17, Colors.white,
                              FontWeight.w600, null, (index == 0) ? 2 : 1.3),
                    ),
                    subtitle: (index == 1)
                        ? Text(
                            sessionManager.getUser().email,
                            textAlign: TextAlign.right,
                            style: AppTextStyles.textStyle(
                                13, Colors.white, FontWeight.w600),
                          )
                        : null,
                    trailing: (index == 1)
                        ? Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                        10 * SizeConfig.heightMultiplier) /
                                    2,
                                child: (null !=
                                            sessionManager.getUser().image &&
                                        sessionManager
                                            .getUser()
                                            .image
                                            .isNotEmpty)
                                    ? Image.network(
                                        sessionManager.getUser().image,
                                        width:
                                            6.5 * SizeConfig.heightMultiplier -
                                                3,
                                        height:
                                            6.5 * SizeConfig.heightMultiplier,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        AppAssets.IC_PROFILE,
                                        width:
                                            6.5 * SizeConfig.heightMultiplier -
                                                3,
                                        color: AppColors.YELLOW,
                                        height:
                                            6.5 * SizeConfig.heightMultiplier,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ],
                          )
                        : Image.asset(
                            icons[index],
                            width: ((index == 0) ? 10 : 4) *
                                SizeConfig.heightMultiplier,
                            height: ((index == 0) ? 10 : 4) *
                                SizeConfig.heightMultiplier,
                          ),
                    onTap: () {
                      handleClick(index);
                    },
                  ),
                );
              }),
        ),
      ),
    );
  }

  void displayLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext cont) => CupertinoAlertDialog(
        title: new Text(
          'تسجيل الخروج',
          style: AppTextStyles.textStyle(20, Colors.black, FontWeight.bold),
        ),
        content: new Text(
          "هل تريد تسجبل الخروج؟",
          style: AppTextStyles.textStyle(16, Colors.black87),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text("موافق",
                style: AppTextStyles.textStyle(16, Colors.blue)),
            onPressed: () {
              Navigator.of(cont).pop("Discard");
              _logoutBloc.handleLogout();
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text("إغلاق",
                style: AppTextStyles.textStyle(16, Colors.blue)),
            onPressed: () {
              Navigator.of(cont).pop("Discard");
            },
          )
        ],
      ),
    );
  }

  handleClick(int index) {
    switch (index) {
      case 2:
        {
          //home
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen()));
          break;
        }
      case 3:
        {
          //profile
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => ProfileScreen()));
          break;
        }
      case 4:
        {
          //my courses
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => CoursesScreen(
                    title: 'دروسي',
                    icon: AppAssets.IC_MY_COURSES,
                    blockType: AppConstants.MY_COURSES,
                    returnedBack: () {},
                  )));
          break;
        }
      case 5:
        {
          //offline courses
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => CoursesScreen(
                    title: 'الكورسات المحملة',
                    icon: AppAssets.IC_OFFLINE_COURSES,
                    blockType: AppConstants.OFFLINE_COURSES,
                    returnedBack: () {},
                  )));
          break;
        }
      case 6:
        {
          //support
          whatsAppOpen();
          break;
        }
      case 7:
        {
          //logout
          displayLogoutDialog(context);
          break;
        }
        Navigator.pop(context);
    }
  }

  void whatsAppOpen() async {
    //bool whatsapp = await FlutterLaunch.hasApp(name: "whatsapp");
    var whatsappUrl =
        "whatsapp://send?phone=${AppConstants.WHATS_PHONE}&text=مرحبأ";
    if (await canLaunch(whatsappUrl)) {
      await canLaunch(whatsappUrl)
          ? launch(whatsappUrl)
          : print(
              "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
      // await FlutterLaunch.launchWathsApp(phone: "${AppConstants.WHATS_PHONE}", message: "مرحبأ");
    } else {
      components.displayDialog(
          context, "", "تطبيق الواتساب غير متوفر على هذا الهاتف");
    }
  }

  void _observeLogout(Result<StatusResponse> result) {
    print("Result Login:: $result");

    if (result is SuccessResult) {
      sessionManager.deleteUser();

      // //clear downloaded videos
      // appUtils.writeContent(
      //     AppConstants.DOWNLOADED_COURSES_CONTENT, json.encode([]));

      if (null != result.getSuccessData().message) {
        components.displayToast(context, result.getSuccessData().message);
      }
      Phoenix.rebirth(context);
    } else if (result is ErrorResult) {
      StatusResponse error = StatusResponse.decodedJson(
          result.getErrorMessage().replaceAll("Exception:", ""));
      if (error.status == 401) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          sessionManager.deleteUser();
          Phoenix.rebirth(context);
        });
      } else {
        components.displayDialog(context, "", result.getErrorMessage());
      }
    }
  }
}
