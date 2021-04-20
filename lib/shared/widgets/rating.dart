import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:adrus/shared/imports.dart';

class MRating extends StatelessWidget {
  final double value;
  final Color color;
  final int itemCount;
  final bool showValue;
  MRating(
      {this.value = 0.0,
      this.itemCount = 5,
      this.color,
      this.showValue = true});
  @override
  Widget build(BuildContext context) {
    final w = context.width;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingBar(
          initialRating: value,
          direction: Axis.horizontal,
          allowHalfRating: true,
          ignoreGestures: true,
          itemCount: itemCount,
          itemSize: w * 0.04,
          ratingWidget: RatingWidget(
            full: Icon(
              Icons.star,
              color: color ?? Color(0xffe8b015),
            ),
            half: Directionality(
              textDirection: TextDirection.ltr,
              child: Icon(
                Icons.star_half,
                color: color ?? Color(0xffe8b015),
              ),
            ),
            empty: Icon(Icons.star,
                color: color != null
                    ? color.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.3)),
          ),
          itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
          onRatingUpdate: (double value) {},
        ).mPadding(end: 5),
        if (showValue)
          MText(
            text: value,
            color: MColors.hintColor,
            isBold: true,
            size: w * 0.03,
          )
      ],
    );
  }
}
