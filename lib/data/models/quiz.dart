import 'dart:convert';

import 'content_data.dart';
import 'instructor_data.dart';
import 'quiz_data.dart';

class Quiz {
  int content_id;
  String title;
  String description;
  String date;
  QuizData quizz;

  Quiz({this.content_id, this.title, this.description, this.date, this.quizz});

  static Quiz fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Quiz(
      content_id: json['content_id'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      quizz: QuizData.fromJson(json['quizz']),
    );
  }

  Map<String, dynamic> toJson() => {
        'content_id': content_id,
        'title': title,
        'description': description,
        'date': date,
        'quizz': quizz
      };

  String encodedJson() => json.encode(toJson());

  static Quiz decodedJson(String source) => fromJson(json.decode(source));

  @override
  String toString() => title;
}
