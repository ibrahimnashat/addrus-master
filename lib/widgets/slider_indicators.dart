import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliderIndicators extends StatelessWidget {
  final int count;
  final int selectedIndex;

  SliderIndicators({
    Key key,
    @required this.count,
    @required this.selectedIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<int> dataList =
        List<int>.generate(count, (int index) => index); //List(count) ;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: dataList.reversed.map((item) {
        int index = dataList.indexOf(item);
        return Container(
          width: 1.2 * SizeConfig.heightMultiplier,
          height: 1.2 * SizeConfig.heightMultiplier,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
              vertical: 4 * SizeConfig.heightMultiplier,
              horizontal: 1 * SizeConfig.heightMultiplier),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selectedIndex == index ? AppColors.YELLOW_DARK : Colors.white  ,
          ),
        );
      }).toList(),
    );
  }
}
