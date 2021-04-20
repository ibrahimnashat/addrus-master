import 'package:adrus/data/models/user_data.dart';
import 'package:adrus/di/injection_container.dart';
import 'package:adrus/ui/elements/my_drawer.dart';
import 'package:adrus/ui/screens/edit_profile_screen.dart';
import 'package:adrus/utils/helpers/app_assets.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/helpers/user_constants.dart';
import 'package:adrus/utils/session_manager.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:adrus/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:adrus/main.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScreenState();
  }
}

class ScreenState extends State<ProfileScreen> {
  SessionManager sessionManager = sl<SessionManager>();
  final Components components = sl<Components>();
  UserData user;

  @override
  void initState() {
    user = sessionManager.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.YELLOW_DARK,
      resizeToAvoidBottomInset: false,
      appBar: components.myAppBar(""),
      endDrawer: Drawer(
        child: MyDrawer(
          currentPagIndex: 2,
        ),
      ),
      body: Builder(
        builder: (scaffoldContext) => Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Positioned.fill(
                          child: Container(
                        color: Colors.black,
                      )),
                      Image.network("${user.image}",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 40 * SizeConfig.heightMultiplier),
                      Positioned.fill(
                        child: Container(
                          color: Color(0xFF000000).withOpacity(0.2),
                        ),
                      ),
                      Positioned(
                        bottom: 1 * SizeConfig.heightMultiplier,
                        right: 1 * SizeConfig.heightMultiplier,
                        left: 0,
                        child: ListTile(
                          title: Text(
                            "${user.name ?? ""}",
                            textAlign: TextAlign.right,
                            style: AppTextStyles.textStyle(
                                18, Colors.white, FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${user.join_date}  " + "تم التسجيل فى تاريخ ",
                            textAlign: TextAlign.right,
                            style: AppTextStyles.textStyle(
                                15, Colors.white, FontWeight.w600),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 3 * SizeConfig.heightMultiplier,
                        left: 3 * SizeConfig.heightMultiplier,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EditProfileScreen(),
                              ),
                            )
                                .then((value) {
                              setState(() {
                                user = sessionManager.getUser();
                                print("user: ${user.image}");
                              });
                            });
                          },
                          child: Image.asset(
                            AppAssets.IC_EDIT,
                            width: 4 * SizeConfig.heightMultiplier,
                            height: 4 * SizeConfig.heightMultiplier,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      margin:
                          EdgeInsets.only(top: 5 * SizeConfig.heightMultiplier),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          numberTextBlock(
                              sessionManager
                                  .getValue(UserConstants.DOWNLOADED_COURSES),
                              "الكورسات المحملة",
                              23 * SizeConfig.heightMultiplier,
                              40 * SizeConfig.heightMultiplier),
                          Column(
                            children: [
                              numberTextBlock(
                                  sessionManager
                                      .getValue(UserConstants.JOINED_COURSES),
                                  "الكورسات المشترك فيها",
                                  23 * SizeConfig.heightMultiplier,
                                  20 * SizeConfig.heightMultiplier),
                              numberTextBlock(
                                  sessionManager
                                      .getValue(UserConstants.COURSES_COST),
                                  "التكلفة بالدينار الليبى",
                                  23 * SizeConfig.heightMultiplier,
                                  20 * SizeConfig.heightMultiplier),
                            ],
                          )
                        ],
                      )),
                  SizedBox(
                    height: 4 * SizeConfig.heightMultiplier,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget numberTextBlock(
      String count, String title, double width, double height) {
    return Container(
      color: Colors.white,
      child: Container(
          width: width,
          height: height,
          padding: AppStyles.paddingSymmetric(2, 3),
          decoration: AppStyles.gradientWhiteGrayDarkDecoration(),
          child: Center(
            child: ListTile(
              title: Text(
                (count.isEmpty) ? "0" : count,
                textAlign: TextAlign.center,
                style:
                    AppTextStyles.textStyle(30, Colors.black, FontWeight.bold),
              ),
              subtitle: Text(
                title,
                textAlign: TextAlign.center,
                style:
                    AppTextStyles.textStyle(16, Colors.black, FontWeight.bold),
              ),
            ),
          )),
    );
  }
}
