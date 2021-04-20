import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/Answer.dart';
import 'package:adrus/data/models/option.dart';
import 'package:adrus/data/models/quiz.dart';
import 'package:adrus/data/models/responses/answer_question_response.dart';
import 'package:adrus/data/models/responses/status_response.dart';
import 'package:adrus/di/injection_container.dart';
import 'package:adrus/ui/bloc/bloc_answer_question.dart';
import 'package:adrus/ui/screens/screen_quiz_result.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/message.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:adrus/widgets/components.dart';
import 'package:adrus/widgets/my_button.dart';
import 'package:adrus/widgets/slider_indicators.dart';
import 'package:flutter/material.dart';
import 'package:adrus/main.dart';

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  QuizScreen({
    @required this.quiz,
  });

  @override
  State<StatefulWidget> createState() {
    return ScreenState(quiz);
  }
}

class ScreenState extends State<QuizScreen> {
  Quiz quiz;

  ScreenState(this.quiz);

  final Components components = sl<Components>();
  final AnswerQuestionBloc _answerQuestionBloc = sl<AnswerQuestionBloc>();

  var currentQuestionIndex = 0;
  List<Answer> questionsAnswers;
  DateTime initialDate;
  DateTime endDate;

  @override
  void initState() {
    questionsAnswers = List.filled(
        quiz.quizz.questions.length, Answer(question_id: "", answer: ""));
    _answerQuestionBloc.mainStream.listen(_observeAnswerQuestion);
    initialDate = DateTime.now();

    super.initState();
  }

  @override
  void dispose() {
    _answerQuestionBloc.dispose();
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
                margin: AppStyles.paddingSymmetric(2, 2),
                padding: EdgeInsets.zero,
                child: Stack(
                  children: [
                    ListView(padding: EdgeInsets.all(0.0), children: <Widget>[
                      ListTile(
                        contentPadding: AppStyles.paddingSymmetric(2, 2),
                        title: Text(
                          quiz.quizz.name ?? "",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.textStyle(
                              14, Colors.white, FontWeight.w700, null, 2),
                        ),
                        // trailing: Icon(
                        //   Icons.article_outlined,
                        //   color: Colors.white,
                        //   size: 3 * SizeConfig.heightMultiplier,
                        // ),
                      ),
                      SizedBox(height: 2 * SizeConfig.heightMultiplier),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${quiz.quizz.date ?? ""}  :",
                            textAlign: TextAlign.right,
                            style: AppTextStyles.textStyle(
                                12, Colors.white, FontWeight.w500, null, 2),
                          ),
                          Text(
                            "تاريخ الإختبار",
                            textAlign: TextAlign.right,
                            style: AppTextStyles.textStyle(
                                12, Colors.white, FontWeight.w500, null, 2),
                          ),
                          Icon(
                            Icons.date_range_outlined,
                            color: Colors.white,
                            size: 3 * SizeConfig.heightMultiplier,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "وقت الإختبار:  ${quiz.quizz.quizz_time} دقيقة",
                            textAlign: TextAlign.right,
                            style: AppTextStyles.textStyle(
                                12, Colors.white, FontWeight.w500, null, 2),
                          ),
                          Icon(
                            Icons.access_time_outlined,
                            color: Colors.white,
                            size: 3 * SizeConfig.heightMultiplier,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3 * SizeConfig.heightMultiplier,
                      ),
                      Container(
                        height: 0.5,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 2 * SizeConfig.heightMultiplier,
                      ),
                      Text(
                        "السؤال  ${currentQuestionIndex + 1}",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.textStyle(
                            16, Colors.white70, FontWeight.w700, null, 2),
                      ),
                      SizedBox(height: 2 * SizeConfig.heightMultiplier),
                      Text(
                        quiz.quizz.questions[currentQuestionIndex].question ??
                            "",
                        textAlign: TextAlign.right,
                        style: AppTextStyles.textStyle(
                            14, Colors.white, FontWeight.w600, null, 2),
                      ),
                      answersBlock(
                          quiz.quizz.questions[currentQuestionIndex].options),
                      Center(
                        child: MyButton(
                          title: "التالي",
                          fillWidth: false,
                          bkgColor: AppColors.YELLOW_DARK,
                          showShadow: false,
                          fontWight: FontWeight.bold,
                          titleSize: 14,
                          height: 7,
                          width: 40,
                          decoration: AppStyles.decorationRoundedColored(
                              AppColors.YELLOW_DARK, 1),
                          onTap: () {
                            if (questionsAnswers[currentQuestionIndex]
                                .answer
                                .isEmpty) {
                              components.displayDialog(
                                  context, "", "اختر إجابة للسؤال أولاً");
                            } else {
                              setState(() {
                                if (currentQuestionIndex <
                                    quiz.quizz.questions.length - 1) {
                                  currentQuestionIndex += 1;
                                } else {
                                  print("finish");
                                  endDate = DateTime.now();
                                  int difference =
                                      endDate.difference(initialDate).inSeconds;
                                  int minutes = difference ~/ 60;
                                  int seconds = difference % 60;
                                  print(
                                      "difference: $difference - $minutes - $seconds");
                                  _answerQuestionBloc.answerQuestion(
                                      quiz.quizz.id,
                                      quiz.content_id,
                                      questionsAnswers,
                                      minutes,
                                      seconds);
                                }
                              });
                            }
                            print("Answers: ${questionsAnswers}");
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SliderIndicators(
                              count: quiz.quizz.questions.length,
                              selectedIndex: currentQuestionIndex),
                        ],
                      )
                    ]),
                  ],
                ),
              )),
    );
  }

  Widget answersBlock(List<Option> answers) {
    return Container(
      padding: AppStyles.paddingSymmetric(2, 2),
      color: AppColors.BLUE_DARK,
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: answers.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  questionsAnswers[currentQuestionIndex] = Answer(
                      question_id: quiz.quizz.questions[currentQuestionIndex].id
                          .toString(),
                      answer: answers[index].index);
                });
              },
              child: Container(
                padding: AppStyles.paddingSymmetric(2, 1),
                margin: AppStyles.paddingSymmetric(0, 1),
                decoration: AppStyles.decorationRoundedColored(
                    answers[index].index ==
                            questionsAnswers[currentQuestionIndex].answer
                        ? Colors.white70
                        : Colors.white,
                    1),
                child: Text(
                  answers[index].answer ?? "",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.textStyle(
                      16,
                      answers[index].index ==
                              questionsAnswers[currentQuestionIndex].answer
                          ? Colors.black87
                          : AppColors.BLUE_DARK,
                      FontWeight.w700,
                      null,
                      2),
                ),
              ),
            );
          }),
    );
  }

  //------------
  void _observeAnswerQuestion(Result<AnswerQuestionResponse> result) {
    print("Result Login:: ${result.getSuccessData()}");

    if (result is SuccessResult) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              QuizResultScreen(response: result.getSuccessData())));
    } else if (result is ErrorResult) {
      components.displayDialog(
          context, Message.ERROR_HAPPENED, result.getErrorMessage());
    }
  }
}
