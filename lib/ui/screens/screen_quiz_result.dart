import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/State_data.dart';
import 'package:adrus/data/models/option.dart';
import 'package:adrus/data/models/quiz.dart';
import 'package:adrus/data/models/responses/answer_question_response.dart';
import 'package:adrus/data/models/responses/status_response.dart';
import 'package:adrus/di/injection_container.dart';
import 'package:adrus/ui/bloc/bloc_answer_question.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_constants.dart';
import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/message.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:adrus/widgets/components.dart';
import 'package:adrus/widgets/my_button.dart';
import 'package:adrus/widgets/slider_indicators.dart';
import 'package:flutter/material.dart';
import 'package:adrus/main.dart';

class QuizResultScreen extends StatefulWidget {
  final AnswerQuestionResponse response;

  QuizResultScreen({
    @required this.response,
  });

  @override
  State<StatefulWidget> createState() {
    return ScreenState(response);
  }
}

class ScreenState extends State<QuizResultScreen> {
  AnswerQuestionResponse response;

  ScreenState(this.response);

  final Components components = sl<Components>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BLUE_DARK,
      resizeToAvoidBottomInset: false,
      appBar: components.myAppBar("", true),
      body: Builder(
          builder: (scaffoldContext) => Container(
                margin: AppStyles.paddingSymmetric(4, 6),
                padding: EdgeInsets.zero,
                alignment: Alignment.center,
                child: Center(
                  child:
                      ListView(padding: EdgeInsets.all(0.0), children: <Widget>[
                    Text(
                      " ${response.state.status ?? ""}  : النتيجة  ",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.textStyle(
                          20, AppColors.YELLOW_DARK, FontWeight.w900, null, 2),
                    ),
                    SizedBox(
                      height: 4 * SizeConfig.heightMultiplier,
                    ),
                    Text(
                      "نتيجة الإختبار الخاص بك:   ${response.state.score ?? ""}   درجة",
                      textAlign: TextAlign.right,
                      style: AppTextStyles.textStyle(
                          16, Colors.white, FontWeight.w500, null, 2),
                    ),
                    Text(
                      "عدد الإجابات الصحيحة:   ${response.state.right ?? ""}   إجابة",
                      textAlign: TextAlign.right,
                      style: AppTextStyles.textStyle(
                          16, Colors.white, FontWeight.w500, null, 2),
                    ),
                    Text(
                      "عدد الإجابات الخاطئة:   ${response.state.wrong ?? ""}   إجابة",
                      textAlign: TextAlign.right,
                      style: AppTextStyles.textStyle(
                          16, Colors.white, FontWeight.w500, null, 2),
                    ),
                    Text(
                      "اكملت الإختبار فى وقت:   ${response.state.wrong ?? ""}   دقيقة",
                      textAlign: TextAlign.right,
                      style: AppTextStyles.textStyle(
                          16, Colors.white, FontWeight.w500, null, 2),
                    ),
                  ]),
                ),
              )),
    );
  }
}
