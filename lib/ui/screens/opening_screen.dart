import 'package:adrus/di/injection_container.dart';
import 'package:adrus/ui/screens/login_screen.dart';
import 'package:adrus/utils/helpers/app_assets.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/session_manager.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpeningScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScreenState();
  }
}

class ScreenState extends State<OpeningScreen> {
  String messageContent =
      "التطبيق صمم ليسمح لك بمشاهدة فقط الدورات التي إشتركت بها عبر منصة أدرس .\n يتوجب عليك الدخول للمنصة و التسجيل للإشتراك في الدورات التي تناسبك لتتمكن من عرضها من خلال التطبيق.\n حمل دروسك عبر التطبيق و شاهد دروسك حتى مع عدم وجود إنترنت.";
  int currentSlideIndex = 0;
  SessionManager sessionManager = sl<SessionManager>();

  launchURL() async {
    var url = "www.addrus.com";
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BKG,
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (scaffoldContext) => Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      color: Colors.black,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Image.asset(
                        AppAssets.LOGIN_HEADER,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Positioned(
                    //   left: 0,
                    //   right: 0,
                    //   bottom: 4 * SizeConfig.heightMultiplier,
                    //   child: Image.asset(
                    //     AppAssets.LOGO_TRANSPARENT_BLUE,
                    //     width: 35 * SizeConfig.heightMultiplier,
                    //     height: 35 * SizeConfig.heightMultiplier,
                    //     fit: BoxFit.contain,
                    //   ),
                    // )
                  ],
                )),
                Container(
                  color: AppColors.BLUE_MED,
                  padding: AppStyles.paddingSymmetric(5, 3),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      Text(
                        "تعلم أينما كنت",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textStyle(
                            22, Colors.white, FontWeight.w900),
                      ),
                      SizedBox(
                        height: 2 * SizeConfig.heightMultiplier,
                      ),
                      Text(
                        messageContent,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textStyle(
                            14, Colors.white, FontWeight.normal, null, 1.8),
                      ),
                      (currentSlideIndex == 0)
                          ? InkWell(
                              onTap: () {
                                launchURL();
                              },
                              child: Text(
                                "www.addrus.com",
                                textAlign: TextAlign.center,
                                style: AppTextStyles.textStyle(14, Colors.white,
                                    FontWeight.normal, null, 1.8),
                              ),
                            )
                          : Center(),
                      SizedBox(
                        height: 2 * SizeConfig.heightMultiplier,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              // setState(() {
                              //   if (currentSlideIndex < 2) {
                              //     currentSlideIndex = currentSlideIndex + 1;
                              //   } else {
                              //     sessionManager.setValue(
                              //         UserConstants.OPENING_SCREEN_SEEN,
                              //         "true");
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          LoginScreen()));
                              //   }
                              // });
                            },
                            child: Text(
                              "التالي",
                              textAlign: TextAlign.center,
                              style: AppTextStyles.textStyle(
                                  16, AppColors.YELLOW_DARK, FontWeight.w900),
                            ),
                          ),
                          // SliderIndicators(
                          //     count: 3, selectedIndex: currentSlideIndex),
                          // InkWell(
                          //   onTap: () {
                          //     sessionManager.setValue(
                          //         UserConstants.OPENING_SCREEN_SEEN, "true");
                          //     Navigator.of(context).pushReplacement(
                          //         MaterialPageRoute(
                          //             builder: (BuildContext context) =>
                          //                 LoginScreen()));
                          //   },
                          //   child: Text(
                          //     "تخطي",
                          //     textAlign: TextAlign.center,
                          //     style: AppTextStyles.textStyle(
                          //         14, AppColors.TEXT_COLOR, FontWeight.w900),
                          //   ),
                          // ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
