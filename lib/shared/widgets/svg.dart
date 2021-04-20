import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:adrus/shared/imports.dart';

// ignore: must_be_immutable
class MIcon extends StatelessWidget {
  final String name;

  final Color color;
  final double width;
  final double height;
  BoxFit fit;
  final bool fromNet;

  MIcon({
    this.name,
    this.color,
    this.width,
    this.height,
    this.fromNet = false,
    this.fit = BoxFit.scaleDown,
  });
  bool _isFinished = false;
  @override
  Widget build(BuildContext context) {
    var myWidget;
    if (fromNet) {
      if (name.split(".").last == "svg") {
        myWidget = SvgPicture.network(
          name,
          width: width,
          color: color,
          height: height,
          fit: fit,
          placeholderBuilder: (context) => CircularProgressIndicator(),
        );
      }
      myWidget = Container(
        width: width,
        height: height,
        child: MImage(
          url: name,
          width: width,
          color: color,
          height: height,
          fit: fit,
        ),
      );
    }
    if (color != null)
      myWidget = SvgPicture.asset(
        'assets/$name.svg',
        width: width,
        color: _isFinished ? Colors.black : color,
        height: height,
        fit: fit,
      );

    myWidget = SvgPicture.asset(
      'assets/$name.svg',
      width: width,
      height: height,
      color: color,
      fit: fit,
    );

    return //lang == "en"
        //?
        myWidget;
    // : Transform(
    //     alignment: Alignment.center,
    //     transform: Matrix4.rotationY(pi),
    //     child: myWidget);
  }
}

extension SvggAppExtension on MIcon {
  Widget circle() {
    this.fit = BoxFit.fill;
    return ClipRRect(
      child: this,
      borderRadius: BorderRadius.circular(200),
    );
  }
}
