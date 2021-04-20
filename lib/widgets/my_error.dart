import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:flutter/material.dart';

class MyError extends StatelessWidget {
  final String errorMsg;
  final Color textColor ;

  MyError(this.errorMsg, [this.textColor]);

  @override
  Widget build(BuildContext context) {
    print("Error: $errorMsg");
    return Container(
      padding: AppStyles.paddingSymmetric(2, 3),
      child: Center(
        child: Text(
          errorMsg,
          style: AppTextStyles.textStyle(16, (null != textColor)? textColor : Colors.black87),
        ),
      ),
    );
  }
}
