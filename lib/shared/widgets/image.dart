import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:adrus/shared/imports.dart';

// ignore: must_be_immutable
class MImage extends StatelessWidget {
  final String baseurl = '';
  final Map<String, dynamic> obj;
  final String prop;
  final double width;
  final double height;
  final String mode;
  final String path;
  final String format;
  final String def;
  final Color color;
  final bool isBgImage;
  bool isGray;
  final bool isThumb;
  final String url;
  final List<BoxShadow> shadow;
  BoxFit fit;
  final bool isSvg;
  MImage({
    this.obj,
    this.prop,
    this.shadow = const [],
    this.url,
    this.path,
    this.fit = BoxFit.cover,
    this.isSvg = false,
    this.color,
    this.isGray = false,
    this.isThumb = false,
    this.width = 600,
    this.height = 600,
    this.mode = 'crop',
    this.def = 'no-image',
    this.format = 'png',
    this.isBgImage = false,
  });

  String getUrl() {
    if (path != null) return path;
    if (url != null) return url;
    String myurl;

    if (obj.keys.length > 0 && obj[prop] != null) {
      myurl = obj[prop]['url'];
    }
    return myurl;
  }

  dynamic imageNet() {
    // ignore: unused_local_variable
    var defImg = Image.asset(
      'assets/${def == null ? "no-image" : def}.png',
      color: !isGray ? null : Colors.grey.withOpacity(1.0),
      colorBlendMode: !isGray ? null : BlendMode.saturation,
    );

    try {
      return CachedNetworkImageProvider(
        getUrl(),
      );
    } catch (e) {
      return AssetImage("assets/${def == null ? "no-image" : def}.png");
    }
  }

  Widget build(BuildContext context) {
    var defImg;
    if (!isSvg)
      defImg = Image.asset(
        'assets/${def == null ? "no-image" : def}.png',
        color: !isGray ? null : Colors.grey.withOpacity(1.0),
        fit: fit,
        colorBlendMode: !isGray ? null : BlendMode.saturation,
      );
    else
      defImg = Container(
        width: width.toDouble(),
        height: height.toDouble(),
        child: MIcon(
          name: def,
          width: width.toDouble(),
          height: height.toDouble(),
          fit: fit,
          color: color,
        ),
      );

    try {
      if (path != null) {
        return Container(
          width: width.toDouble(),
          height: height.toDouble(),
          child: Image.asset(
            'assets/$path.png',
            width: width.toDouble(),
            height: height.toDouble(),
            fit: fit,
            color: !isGray ? null : Colors.grey.withOpacity(1.0),
            colorBlendMode: !isGray ? null : BlendMode.saturation,
          ),
        );
      }

      var loader = Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.vertical,
        runAlignment: WrapAlignment.center,
        children: [
          Container(
            width: width,
            height: height,
            child: SpinKitDualRing(
              color: Colors.grey.withOpacity(0.2),
            ),
          )
        ],
      );

      var url = getUrl();
      //print(url);
      if (url == null || url.length == 0) return defImg;

      if (url.indexOf(".svg") > -1) {
        return Container(
          width: width.toDouble(),
          height: height.toDouble(),
          child: SvgPicture.network(
            url,
            color: color,
            colorBlendMode: !isGray ? null : BlendMode.color,
            placeholderBuilder: (BuildContext context) => loader,
          ),
        );
      }

      return Container(
        width: width.toDouble(),
        height: height.toDouble(),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.fitWidth,
          imageBuilder: (context, imageProvider) => Container(
            height: height.toDouble(),
            decoration: BoxDecoration(
              boxShadow: shadow,
              image: DecorationImage(
                image: imageProvider,
                fit: fit,
                colorFilter: !isGray
                    ? null
                    : ColorFilter.mode(
                        Colors.grey,
                        BlendMode.saturation,
                      ),
              ),
            ),
          ),
          placeholder: (context, url) => loader,
          errorWidget: (context, exception, stackTrace) {
            return Container(
              width: width.toDouble(),
              height: height.toDouble(),
              child: defImg,
            );
          },
        ),
      );
    } catch (e) {}
    return Container(
      width: width.toDouble(),
      height: height.toDouble(),
      child: defImg,
    );
  }
}

extension ImageAppExtension on MImage {
  Widget circle({Color color}) {
    return Container(
      decoration: color != null
          ? BoxDecoration(
              border: Border.all(width: 3, color: color),
              shape: BoxShape.circle)
          : null,
      child: ClipRRect(
        child: Container(
          child: this,
          width: this.width.toDouble(),
          height: this.height.toDouble(),
        ),
        borderRadius: BorderRadius.circular(200),
      ),
    );
  }

  Widget radius({double radius = 0}) {
    return ClipRRect(
      child: this,
      borderRadius: BorderRadius.circular(radius),
    );
  }
}
