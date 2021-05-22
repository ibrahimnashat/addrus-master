import 'dart:convert';

import 'package:adrus/di/injection_container.dart';
import 'package:adrus/shared/imports.dart';
import 'package:adrus/ui/elements/home_block.dart';
import 'package:adrus/ui/elements/home_image_slider.dart';
import 'package:adrus/ui/elements/my_drawer.dart';
import 'package:adrus/ui/screens/course_preview_screen.dart';
import 'package:adrus/utils/helpers/app_assets.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_constants.dart';
import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/widgets/components.dart';
import 'package:fcm_config/fcm_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adrus/shared/widgets/drag_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScreenState();
  }
}

class ScreenState extends State<HomeScreen> {
  final Components components = sl<Components>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        appBar: components.myAppBar(""),
        endDrawer: Drawer(
          child: MyDrawer(
            currentPagIndex: 1,
          ),
        ),
        body: FCMNotificationListener(
          onNotification:
              (RemoteMessage notification, void Function() setState) {},
          child: Container(
            color: AppColors.BLUE_DARK,
            child: Builder(
              builder: (scaffoldContext) => ListView(
                shrinkWrap: false,
                children: [
                  HomeImageSlider(),
                  HomeBlock(
                    title: 'الدروس المحملة',
                    icon: AppAssets.IC_OFFLINE_COURSES,
                    blockType: AppConstants.OFFLINE_COURSES,
                    color: AppColors.BLUE_DARK,
                    returnedBack: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => this.build(context)));
                    },
                  ),
                  HomeBlock(
                    title: 'دروسي',
                    icon: AppAssets.IC_MY_COURSES,
                    blockType: AppConstants.MY_COURSES,
                    color: AppColors.BLUE_MED,
                    returnedBack: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => this.build(context)));
                    },
                  )
                ],
              ),
            ),
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
                  style: AppTextStyles.textStyle(
                      14, Colors.orange, FontWeight.bold),
                ),
              );
            return SizedBox();
          }),
        ),
      ),
    );
  }

  Future<bool> onWillPop() async {
    final value = await showDialog(
      context: context,
      builder: (BuildContext cont) => CupertinoAlertDialog(
        title: new Text(
          'الخروج من التطبيق',
          style: AppTextStyles.textStyle(16, Colors.black, FontWeight.bold),
        ),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Text(
            "هل تريد الخروج من التطبيق؟",
            style: AppTextStyles.textStyle(12, Colors.black87),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text("نعم",
                style: AppTextStyles.textStyle(16, Colors.blue)),
            onPressed: () {
              context.pop(true);
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child:
                new Text("لا", style: AppTextStyles.textStyle(16, Colors.blue)),
            onPressed: () {
              context.pop(false);
            },
          )
        ],
      ),
    );
    return value;
  }

  @override
  void onClick(RemoteMessage notification) {
    // TODO: implement onClick
  }

  @override
  void onNotify(RemoteMessage notification) {
    // TODO: implement onNotify
  }
}
