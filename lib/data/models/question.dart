import 'dart:convert';

import 'package:adrus/data/models/option.dart';

import 'class_data.dart';
import 'instructor_data.dart';

class Question {
  int id;
  String question;
  int grade;
  List<Option> options;

  Question({
    this.id,
    this.question,
    this.grade,
    this.options,
  });

  static Question fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Question(
      id: json['id'],
      question: json['question'],
      grade: json['grade'],
      options: (null != json['options'])
          ? (json['options'] as List)
                  .map((itemWord) => Option.fromJson(itemWord))
                  .toList() ??
              []
          : List<Option>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'grade': grade,
        'options': options,
        'question': question,
      };

  String encodedJson() => json.encode(toJson());

  static Question decodedJson(String source) => fromJson(json.decode(source));
}
