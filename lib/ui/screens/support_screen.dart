import 'dart:io';

import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/responses/status_response.dart';
import 'package:adrus/data/models/responses/support_response.dart';
import 'package:adrus/data/models/support_data.dart';
import 'package:adrus/di/injection_container.dart';
import 'package:adrus/ui/bloc/bloc_register.dart';
import 'package:adrus/ui/bloc/bloc_support.dart';
import 'package:adrus/ui/elements/my_drawer.dart';
import 'package:adrus/utils/helpers/app_assets.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_constants.dart';
import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/message.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/session_manager.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:adrus/widgets/components.dart';
import 'package:adrus/widgets/loading_indicator.dart';
import 'package:adrus/widgets/my_error.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:adrus/main.dart';

class SupportScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScreenState();
  }
}

class ScreenState extends State<SupportScreen> {
  SessionManager sessionManager = sl<SessionManager>();
  final Components components = sl<Components>();
  final SupportBloc _supportBloc = sl<SupportBloc>();

  bool isLoading = false;

  @override
  void initState() {
    _supportBloc.getSupport();
    super.initState();
  }

  @override
  void dispose() {
    // _supportBloc.dispose();
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
        child: MyDrawer(currentPagIndex: 5),
      ),
      body: Builder(
        builder: (scaffoldContext) => SingleChildScrollView(
          child: getSupportData(),
        ),
      ),
    );
  }

  getSupportData() {
    return StreamBuilder<Result<SupportResponse>>(
        stream: _supportBloc.mainStream,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            Result<SupportResponse> result = snapshot.data;
            if (result is SuccessResult) {
              if (null != result.getSuccessData().data) {
                return _buildContent(result.getSuccessData().data);
              } else {
                return MyError(Message.NO_CONTENT);
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
                  //offline
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

  Widget _buildContent(SupportData data) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: AppStyles.paddingSymmetric(4, 4),
          margin: EdgeInsets.only(bottom: 3 * SizeConfig.heightMultiplier),
          color: AppColors.YELLOW_DARK,
          child: Text(
            "الدعم الفني",
            textAlign: TextAlign.center,
            style: AppTextStyles.textStyle(20, Colors.white, FontWeight.w900),
          ),
        ),
        (data.support_content.isNotEmpty)
            ? ListTile(
                title: Text(
                  "مركز الدعم",
                  textAlign: TextAlign.right,
                  style: AppTextStyles.textStyle(
                      14, Colors.white, FontWeight.bold),
                ),
                subtitle: components.getHtmContent(data.support_content ?? ""),
              )
            : Center(),
        ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            InkWell(
              onTap: () {
                whatsAppOpen();
              },
              child: phoneBlock(AppAssets.IC_WHATS_APP, "افتح تطبيق واتساب",
                  "تواصل مع فريق الدعم"),
            ),
            InkWell(
              onTap: () {
                _makePhoneCall('tel:${AppConstants.WHATS_PHONE}');
              },
              child: phoneBlock(AppAssets.IC_PHONE, "اتصل هاتفيا بالرقم",
                  "اتصل هاتفيا مع فريق الدعم"),
            )
          ],
        )
        //  Container(
        //    height: 24 * SizeConfig.heightMultiplier,
        //    alignment: Alignment.center,
        //    child: ,
        //  )
        // ,
        // (getBlockData(supportData, 4).isNotEmpty)
        //     ? ListTile(
        //         title: Text(
        //           "المركز التقنى",
        //           textAlign: TextAlign.right,
        //           style: AppTextStyles.textStyle(
        //               14, Colors.white, FontWeight.bold),
        //         ),
        //         subtitle: components
        //             .getHtmContent(getBlockData(supportData, 4)[0].body),
        //       )
        //     : Center(),
      ],
    );
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

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget phoneBlock(String icon, String title, String desc) {
    return Container(
      height: 20 * SizeConfig.heightMultiplier,
      color: Color(0xFFaaaaaa).withOpacity(0.3),
      margin: AppStyles.paddingSymmetric(5, 1),
      padding: AppStyles.paddingSymmetric(2, 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 5 * SizeConfig.heightMultiplier,
            height: 5 * SizeConfig.heightMultiplier,
          ),
          ListTile(
            contentPadding:
                EdgeInsets.only(top: 0.5 * SizeConfig.heightMultiplier),
            title: Text(
              title ?? "",
              textAlign: TextAlign.center,
              style: AppTextStyles.textStyle(14, Colors.white, FontWeight.bold),
            ),
            subtitle: Text(
              desc ?? "",
              textAlign: TextAlign.center,
              style:
                  AppTextStyles.textStyle(14, Colors.white, FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
