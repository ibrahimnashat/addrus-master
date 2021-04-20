import 'dart:io';

import 'package:adrus/base/base_bloc.dart';
import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/Answer.dart';
import 'package:adrus/data/models/responses/answer_question_response.dart';
import 'package:adrus/data/models/responses/login_response.dart';
import 'package:adrus/data/models/responses/status_response.dart';
import 'package:adrus/data/repo/repo_home.dart';
import 'package:adrus/data/repo/repo_user.dart';


class AnswerQuestionBloc extends BaseBloc<Result<AnswerQuestionResponse>> {
  HomeRepo repository;

  AnswerQuestionBloc(this.repository);

  Future<void> answerQuestion(int quiz_id,
      int content_id,
      List<Answer> question,
      int exam_minutes,
      int exam_seconds,) async {
    emit(Result.loading());
    try {
      var result = await repository.answerQuestion( quiz_id,
         content_id,
         question,
         exam_minutes,
         exam_seconds,);
      emit(Result.success(result));
    } on Exception catch (e) {
      print("Error: ${e.toString()}");
      emit(Result.error(e.toString()));
    }
  }
}
