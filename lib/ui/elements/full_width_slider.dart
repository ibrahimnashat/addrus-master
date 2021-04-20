import 'package:adrus/data/models/slider_data.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';


class FullWidthSlider extends StatefulWidget {
  final int sliderHeight;

  final List<SliderData> sliderDataList;
  final List<String> imagesList;

  FullWidthSlider(
      {Key key,
      this.sliderDataList,
      this.imagesList,
      @required this.sliderHeight})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SliderState();
  }
}

class _SliderState extends State<FullWidthSlider> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        sliderImage(widget.sliderDataList, widget.imagesList),
        sliderIndicators(widget.sliderDataList, widget.imagesList)
      ],
    );
  }

  Widget sliderImage(List<SliderData> sliderDataList, List<String> imagesList) {
    return Builder(
      builder: (context) {
        final double h = MediaQuery.of(context).size.height;
        final double w = MediaQuery.of(context).size.width;
        return CarouselSlider(
          options: CarouselOptions(
              height: widget.sliderHeight * SizeConfig.heightMultiplier,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 5),
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
          items: (null != sliderDataList && sliderDataList.isNotEmpty)
              ? sliderDataList.map((item) {
            return Container(
              child: Image.network(
                item.image,
                fit: BoxFit.contain,
                height: h,
                width: w,
              ),
            );
          }).toList() ?? []
              : imagesList.map((item) {
                    return Container(
                      child: Image.network(
                        item,
                        fit: BoxFit.contain,
                        height: h,
                        width: w,
                      ),
                    );
                  }).toList() ?? [],
        );
      },
    );
  }

  Widget sliderIndicators(
      List<SliderData> sliderDataList, List<String> imagesList) {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: ((null != sliderDataList && sliderDataList.isNotEmpty)
                    ? sliderDataList
                    : imagesList)
                .map((url) {
              int index = ((null != sliderDataList && sliderDataList.isNotEmpty)
                      ? sliderDataList
                      : imagesList)
                  .indexOf(url);
              return Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? AppColors.PRIMARY
                      : AppColors.GRAY_SHADOW,
                ),
              );
            }).toList() ??
            [],
      ),
    );
  }
}
