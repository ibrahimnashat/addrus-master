import 'dart:convert';

import 'class_data.dart';
import 'instructor_data.dart';

class Answer {
  String question_id;
  String answer;

  Answer(
      {this.question_id,
      this.answer,
     });

  static Answer fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Answer(
      question_id: json['question_id'],
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() => {
        'question_id': question_id,
        'answer': answer,
      };

  String encodedJson() => json.encode(toJson());

  static Answer decodedJson(String source) => fromJson(json.decode(source));


}
