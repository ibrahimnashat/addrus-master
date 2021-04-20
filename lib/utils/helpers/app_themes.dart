import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData myAppTheme = ThemeData(
    primarySwatch: Colors.lightBlue,
    primaryColor: AppColors.PRIMARY,
    accentColor: AppColors.PRIMARY,
    primaryColorDark: AppColors.PRIMARY,
    fontFamily: AppFronts.Bahij,
  );

}