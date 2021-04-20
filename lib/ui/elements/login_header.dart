import 'package:adrus/utils/helpers/app_assets.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(AppAssets.LOGIN_HEADER,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 35 * SizeConfig.heightMultiplier),
       // Positioned.fill(
       //     child:  Center(
       //       child: Image.asset(AppAssets.LOGO_TRANSPARENT_WHITE,
       //           fit: BoxFit.contain,
       //           width: 22 * SizeConfig.heightMultiplier,
       //           height: 22* SizeConfig.heightMultiplier),
       //     ))
      ],
    );
  }

}