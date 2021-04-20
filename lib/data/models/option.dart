import 'dart:convert';

import 'class_data.dart';
import 'instructor_data.dart';

class Option {
  String index;
  String answer;
  String image;

  Option(
      {this.index,
      this.answer,
      this.image,
     });

  static Option fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return Option(
      index: json['index'],
      answer: json['answer'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
        'index': index,
        'answer': answer,
        'image': image,
      };

  String encodedJson() => json.encode(toJson());

  static Option decodedJson(String source) => fromJson(json.decode(source));


}
