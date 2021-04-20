import 'package:adrus/di/injection_container.dart';
import 'package:adrus/main.dart';
import 'package:adrus/utils/app_utils.dart';
import 'package:adrus/utils/helpers/app_assets.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_locales.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as math; // import this
import 'package:universal_html/html.dart' as html;

class Components {
  final AppUtils appUtils = sl<AppUtils>();

  void displayDialog(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext cont) => CupertinoAlertDialog(
        content: Text(
          appUtils.removeBrackets(msg),
          style: AppTextStyles.textStyle(14, Colors.black87),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text("Close",
                style: AppTextStyles.textStyle(16, Colors.blue)),
            onPressed: () {
              Navigator.of(cont).pop("Discard");
            },
          )
        ],
      ),
    );
  }

  displayToast(BuildContext context, String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.GRAY_DARK,
        timeInSecForIosWeb: 400,
        fontSize: 2.0 * SizeConfig.textMultiplier);
  }

  void displaySnakBar(BuildContext context, String msg) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(
          '${msg}',
          style: AppTextStyles.textStyle(14, null),
        ),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Widget flippedWidget(BuildContext context, Widget widget) {
    String locale = Localizations.localeOf(context).languageCode;

    return (locale == AppLocales.AR)
        ? Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: widget,
          )
        : widget;
  }

  Widget myAppBar(String title, [bool hideMenu, widget]) {
    return PreferredSize(
      preferredSize: Size.fromHeight(8 * SizeConfig.heightMultiplier),
      // here the desired height
      child: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          (hideMenu == null)
              ? Builder(
                  builder: (context) => IconButton(
                    icon: Icon(Icons.menu),
                    iconSize: 45,
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                )
              : Center(),
          if (widget != null) widget
        ],
        title: (title.isNotEmpty)
            ? Text(
                title,
                style:
                    AppTextStyles.textStyle(16, Colors.white, FontWeight.bold),
              )
            : Image.asset(
                AppAssets.LOGO_WHITE,
                fit: BoxFit.contain,
                width: 6 * SizeConfig.heightMultiplier,
                height: 6 * SizeConfig.heightMultiplier,
              ),
        // Text("title", textAlign: TextAlign.ce,
      ),
    );
  }

  Widget getHtmContent(String text) {
    final divElement = html.DivElement();
    divElement.appendHtml(text);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Text(
        divElement.innerText,
        style: AppTextStyles.textStyle(14, Colors.white, FontWeight.normal),
        textAlign: TextAlign.start,
      ),
    );
  }
}
