import 'package:adrus/data/models/user_data.dart';
import 'package:adrus/di/injection_container.dart';
import 'package:adrus/ui/screens/home_screen.dart';
import 'package:adrus/ui/screens/login_screen.dart';
import 'package:adrus/utils/helpers/app_assets.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_constants.dart';
import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/helpers/user_constants.dart';
import 'package:adrus/utils/session_manager.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:adrus/widgets/components.dart';
import 'package:adrus/widgets/my_button.dart';
import 'package:adrus/widgets/slider_indicators.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:adrus/main.dart';
import 'support_screen.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScreenState();
  }
}

class ScreenState extends State<WelcomeScreen> {
  SessionManager sessionManager = sl<SessionManager>();
  final Components components = sl<Components>();
  UserData userData;

  @override
  void initState() {
    userData = sessionManager.getUser();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BKG,
      resizeToAvoidBottomInset: false,
      body: Builder(
          builder: (scaffoldContext) => Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppAssets.SPLASH),
                    fit: BoxFit.cover,
                  ),
                ),
                padding: EdgeInsets.only(
                    top: 6 * SizeConfig.heightMultiplier,
                    bottom: 6 * SizeConfig.heightMultiplier,
                    left: 6 * SizeConfig.heightMultiplier,
                    right: 6 * SizeConfig.heightMultiplier),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppAssets.LOGO_WHITE,
                      width: 10 * SizeConfig.heightMultiplier,
                      height: 10 * SizeConfig.heightMultiplier,
                      fit: BoxFit.contain,
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          CircleAvatar(
                            radius: 10 * SizeConfig.heightMultiplier,
                            backgroundColor: AppColors.BLUE_MED,
                            child: CircleAvatar(
                              radius: 10 * SizeConfig.heightMultiplier - 4,
                              backgroundImage: (null !=
                                          sessionManager.getUser().image &&
                                      sessionManager.getUser().image.isNotEmpty)
                                  ? NetworkImage(sessionManager.getUser().image)
                                  : AssetImage(AppAssets.IC_PROFILE),
                              //Image.network()
                            ),
                          ),
                          SizedBox(
                            height: 4 * SizeConfig.heightMultiplier,
                          ),
                          Text(
                            "${userData.name ?? ""}" + " , " + "مرحباً",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.textStyle(
                                24, Colors.white, FontWeight.w900),
                          ),
                          SizedBox(
                            height: 2 * SizeConfig.heightMultiplier,
                          ),
                          Text(
                            "أهلا بك فى تطبيق أٌدرس, هيا بنا لنتعلم\nأشياء جديدة اليوم",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.textStyle(
                              14,
                              Colors.white,
                              FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MyButton(
                            title: "الصفحة الرئيسية",
                            bkgColor: AppColors.YELLOW_DARK,
                            paddingValue: 2,
                            showShadow: false,
                            width: double.infinity,
                            fontWight: FontWeight.bold,
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HomeScreen()));
                            },
                          ),
                          SizedBox(
                            height: 3 * SizeConfig.heightMultiplier,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                // width: 60 * SizeConfig.widthMultiplier,
                                decoration: AppStyles.decorationBottomBorder(
                                    Colors.white, 1),
                                alignment: Alignment.center,
                                child: MyButton(
                                    title:
                                        "   تواصل مع الدعم الفنى عبر الواتساب   ",
                                    bkgColor: Colors.transparent,
                                    paddingValue: 0,
                                    showShadow: false,
                                    textAlign: TextAlign.center,
                                    mainAlignment: MainAxisAlignment.center,
                                    fontWight: FontWeight.normal,
                                    titleColor: Colors.white,
                                    titleSize: 14,
                                    isTextUnderLine: true,
                                    onTap: whatsAppOpen
                                    // {
                                    //   Navigator.of(context).pushReplacement(
                                    //       MaterialPageRoute(
                                    //           builder: (BuildContext context) =>
                                    //               SupportScreen()));
                                    // },
                                    ),
                              )
                            ],
                          ),
                        ])
                  ],
                ),
                // ),
              )),
    );
  }
}
