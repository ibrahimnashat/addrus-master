import 'dart:convert';

import 'package:adrus/data/models/quiz.dart';

import 'content_data.dart';
import 'instructor_data.dart';

class ClassData {
  int id;
  String title;

  List<ContentData> videos;
  List<ContentData> documents;
  List<Quiz> quizzes;


  ClassData(
      {this.id,
      this.title,
      this.videos, this.documents, this.quizzes});

  static ClassData fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return ClassData(
      id: json['id'],
      title: json['title'],
        videos: (null != json['videos'])? (json['videos'] as List)
            .map((itemWord) => ContentData.fromJson(itemWord))
            .toList() ?? [] : List<ContentData>(),
        documents: (null != json['documents'])? (json['documents'] as List)
            .map((itemWord) => ContentData.fromJson(itemWord))
            .toList() ?? [] : List<ContentData>(),
        quizzes: (null != json['quizzes'])? (json['quizzes'] as List)
        .map((itemWord) => Quiz.fromJson(itemWord))
        .toList() ?? [] : List<Quiz>()
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'videos': videos,
    'documents': documents,
    'quizzes': quizzes
      };

  String encodedJson() => json.encode(toJson());

  static ClassData decodedJson(String source) => fromJson(json.decode(source));

  @override
  String toString() => title;
}
