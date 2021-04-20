import 'package:flutter/material.dart';

extension OnContext on BuildContext {
  double get height {
    return MediaQuery.of(this).size.height;
  }

  double get width {
    return MediaQuery.of(this).size.width;
  }

  dynamic push(dynamic screen) async {
    return await Navigator.push(
        this, MaterialPageRoute(builder: (_) => screen));
  }

  void pushReplacement(dynamic screen) {
    Navigator.pushReplacement(this, MaterialPageRoute(builder: (_) => screen));
  }

  void pushAndRemoveUntil(dynamic screen) {
    Navigator.pushAndRemoveUntil(
        this, MaterialPageRoute(builder: (_) => screen), (route) => false);
  }

  dynamic pop([data]) async {
    return Navigator.pop(this, data);
  }
  
}
