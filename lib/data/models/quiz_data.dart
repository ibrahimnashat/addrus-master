import 'dart:convert';

import 'package:adrus/data/models/question.dart';

import 'class_data.dart';
import 'instructor_data.dart';

class QuizData {
  int id;
  String name;
  int quizz_time;
  String date;
  List<Question> questions;

  QuizData(
      {this.id,
      this.name,
      this.quizz_time,
      this.date,
      this.questions,
     });

  static QuizData fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return QuizData(
      id: json['id'],
      name: json['name'],
      quizz_time: json['quizz_time'],
      date: json['date'],
      questions: (null != json['questions'])? (json['questions'] as List)
          .map((itemWord) => Question.fromJson(itemWord))
          .toList() ?? [] : List<Question>(),

    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'quizz_time': quizz_time,
        'date': date,
        'questions': questions,
      };

  String encodedJson() => json.encode(toJson());

  static QuizData decodedJson(String source) => fromJson(json.decode(source));

  @override
  String toString() => name;
}
