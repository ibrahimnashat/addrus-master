
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorLabel extends StatelessWidget {
  final String msg;
  final Color color;

  ErrorLabel({Key key, @required this.msg, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (null != msg && msg.isNotEmpty)
        ? Padding(
            padding: EdgeInsets.fromLTRB(2 * SizeConfig.heightMultiplier, 5,
                20 * SizeConfig.heightMultiplier, 0),
            child:Text(
                    msg,
                    style: AppTextStyles.textStyle(12, Colors.red),
                  ),
          )
        : Center();
  }
}
