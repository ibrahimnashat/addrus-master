import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class MAlerts {
  static void toast(BuildContext context, msg) {
    Toast.show(msg, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }
}
