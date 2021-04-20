import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:adrus/shared/colors.dart';

class MSettings {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static final border =
      UnderlineInputBorder(borderSide: BorderSide(color: MColors.appColor));
  static final double horizontal = 12;
  static final loadingWidth = 0.65;
}
