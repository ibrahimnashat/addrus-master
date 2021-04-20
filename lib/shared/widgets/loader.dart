import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:adrus/shared/imports.dart';

class Mloader {
  static void show(BuildContext context) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Material(
            type: MaterialType.transparency,
            child: Container(
              width: 100.0,
              height: 100.0,
              child: SpinKitCircle(
                color: Colors.white,
                size: 90.0,
              ),
            ),
          ));

  static Widget widget() => Center(
        child: Container(
          width: 100.0,
          height: 100.0,
          child: SpinKitCircle(
            color: Colors.grey,
            size: 90.0,
          ),
        ),
      );

  static Widget widget2() => Center(
        child: Container(
          width: 30.0,
          height: 30.0,
          child: SpinKitHourGlass(
            color: Colors.grey,
            size: 25.0,
          ),
        ),
      );
  static Widget widget3({Color color}) => Center(
        child: Container(
          width: 100.0,
          height: 100.0,
          child: AwesomeLoader(
            loaderType: AwesomeLoader.AwesomeLoader3,
            color: color ?? Colors.blueAccent,
          ),
        ),
      );
  static void dismiss(BuildContext context) => context.pop();

  static void buildLoader(BuildContext context) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Material(
            type: MaterialType.transparency,
            child: Container(
              width: 100.0,
              height: 100.0,
              child: AwesomeLoader(
                loaderType: AwesomeLoader.AwesomeLoader2,
                color: Colors.white,
              ),
            ),
          ));
}
