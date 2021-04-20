import 'package:flutter/material.dart';


class SizeConfig {
  static double _screenWidth;
  static double _screenHeight;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  static double percentMultiplier ;
  //imageSizeMultiplier will be used which will scale texts according to the screen size.
  static double textMultiplier;
  //imageSizeMultiplier will be used which will scale images according to the screen size.
  static double imageSizeMultiplier;
  //heightMultiplier and widthMultiplier can be used for making paddings, margins, Box Constraints, SizedBox, and alike features.widgets responsive
  static double heightMultiplier;
  static double widthMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;


  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      //orientation == Orientation.landscape
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

    _blockSizeHorizontal = _screenWidth / 100; //80; //
    _blockSizeVertical = _screenHeight / 100; //80; //

    percentMultiplier = (_screenWidth / _screenHeight) * 10;

    textMultiplier = _blockSizeVertical;
    imageSizeMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;
    widthMultiplier = _blockSizeHorizontal;
  }
}
