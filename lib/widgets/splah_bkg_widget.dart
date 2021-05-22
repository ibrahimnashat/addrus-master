import 'package:adrus/di/injection_container.dart';
import 'package:adrus/main.dart';
import 'package:adrus/utils/app_utils.dart';
import 'package:adrus/utils/helpers/app_assets.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashBackgroudWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScreenState();
  }
}

class ScreenState extends State<SplashBackgroudWidget> {
  final AppUtils appUtils = sl<AppUtils>();

  @override
  void initState() {
    super.initState();
    AssetsAudioPlayer.newPlayer()
        .open(
          Audio("assets/titireretiti.mp3"),
          autoStart: true,
          showNotification: false,
        )
        .then((value) => null);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return imageSplash();
  }

  Widget imageSplash() {
    return Material(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.SPLASH_LOGO),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.only(
                top: 25 * SizeConfig.heightMultiplier,
                bottom: 6 * SizeConfig.heightMultiplier),
          ),
          Positioned(
              bottom: 20,
              right: 0,
              left: 0,
              child: Center(
                child: Text(
                    "All rights reserved © Addrus E-Learning",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
              ))
        ],
      ),
    );
  }
}

//LOGO_TRANSPARENT_WHITE
