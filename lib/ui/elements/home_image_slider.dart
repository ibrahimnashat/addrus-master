import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/responses/slider_response.dart';
import 'package:adrus/data/models/responses/status_response.dart';
import 'package:adrus/di/injection_container.dart';
import 'package:adrus/ui/bloc/bloc_slider.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/message.dart';
import 'package:adrus/utils/session_manager.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:adrus/widgets/loading_indicator.dart';
import 'package:adrus/widgets/my_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:adrus/main.dart';
import 'full_width_slider.dart';

class HomeImageSlider extends StatefulWidget {
  HomeImageSlider({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeImageSliderState();
  }
}

class _HomeImageSliderState extends State<HomeImageSlider> {
  final SliderBloc _sliderBloc = sl<SliderBloc>();
  SessionManager sessionManager = sl<SessionManager>();

  @override
  void initState() {
    _sliderBloc.getSlider();
    super.initState();
  }

  @override
  void dispose() {
    _sliderBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30 * SizeConfig.heightMultiplier,
      color: AppColors.GRAY_LIGHT,
      child: StreamBuilder<Result<SliderResponse>>(
          stream: _sliderBloc.mainStream,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              Result<SliderResponse> result = snapshot.data;
              if (result is SuccessResult) {
                if (result.getSuccessData().data.sliders.isNotEmpty) {
                  return FullWidthSlider(
                    sliderDataList: result.getSuccessData().data.sliders,
                    imagesList: [],
                    sliderHeight: 33,
                  );
                } else {
                  return MyError(Message.NO_CONTENT);
                }
              } else if (result is ErrorResult) {
                StatusResponse error = StatusResponse.decodedJson(
                    result.getErrorMessage().replaceAll("Exception:", ""));
                if (error.status == 401) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    sessionManager.deleteUser();
                    Phoenix.rebirth(context);
                  });
                  return Center();
                } else {
                  if (result.getErrorMessage().contains("101")) {
                    //offline
                    return MyError("offline");
                  } else {
                    return MyError(result.getErrorMessage());
                  }
                }
              } else {
                return LoadingIndicator(
                  indicatorSize: 3,
                );
              }
            } else {
              return LoadingIndicator(
                indicatorSize: 3,
              );
            }
          }),
    );
  }
}
