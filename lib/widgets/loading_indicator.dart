import 'package:adrus/utils/size_config.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final bool fullScreen;
  final int indicatorSize;

  LoadingIndicator({Key key, this.fullScreen, this.indicatorSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (null != fullScreen && fullScreen)
        ? Container(
              decoration: BoxDecoration(
                  // color: Color.fromRGBO(0, 0, 0, 0.2),
                  ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
          )
        : Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: (null != indicatorSize)? indicatorSize* SizeConfig.heightMultiplier: 5 * SizeConfig.heightMultiplier,
                height: (null != indicatorSize)? indicatorSize* SizeConfig.heightMultiplier: 5 * SizeConfig.heightMultiplier,

                child: CircularProgressIndicator(),
              ),
            ),
          );
  }
}
