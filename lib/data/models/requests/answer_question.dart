import 'dart:convert';

import 'package:adrus/base/base_body.dart';
import 'package:adrus/base/base_model.dart';

import '../Answer.dart';


class AnswerQuestion extends BaseModel {
  int quiz_id;
  int content_id;
  List<Answer> question;
  int exam_minutes;
  int exam_seconds;

  AnswerQuestion({this.quiz_id, this.content_id, this.question,this.exam_minutes, this.exam_seconds});

  static String getBaseBodyJson({
    int quiz_id,
    int content_id,
    List<Answer> question,
    int exam_minutes,
    int exam_seconds,
  }) {
    return BaseBody(
      AnswerQuestion(quiz_id: quiz_id, content_id: content_id, question: question, exam_minutes: exam_minutes, exam_seconds: exam_seconds),
    ).toJson();
  }

  @override
  AnswerQuestion fromJson(Map<String, dynamic> json) {
    return AnswerQuestion(
      quiz_id: json['quiz_id'],
      content_id: json['content_id'],
      question: (null != json['question'])? (json['question'] as List)
          .map((itemWord) => Answer.fromJson(itemWord))
          .toList() ?? [] : List<Answer>(),
      exam_minutes: json['exam_minutes'],
      exam_seconds: json['exam_seconds'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quiz_id'] = this.quiz_id;
    data['content_id'] = this.content_id;
    data['question'] = this.question;
    data['exam_minutes'] = this.exam_minutes;
    data['exam_seconds'] = this.exam_seconds;
    return data;
  }

  String encodedJson() => json.encode(toJson());
}
