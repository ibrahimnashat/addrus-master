import 'dart:convert';

import 'class_data.dart';
import 'instructor_data.dart';

class CourseData {
  int id;
  String title;
  String short_description;
  String big_description;
  String image;
  String overview_url;

  Object is_free;
  Object price;
  int is_discount;
  Object discount_price;
  num total_enroll;

  List<String> requirement;
  List<String> outcome;
  InstructorData category;
  InstructorData instructor;
  int is_favourited;
  String language;
  List<ClassData> classes;
  bool videoDownloaded;



  CourseData(
      {this.id,
      this.title,
      this.short_description,
      this.big_description,
      this.image,
      this.overview_url,
      this.is_free,
      this.price,
      this.is_discount,
      this.discount_price,
      this.total_enroll,
      this.requirement,
      this.outcome,
      this.category,
      this.instructor,
      this.is_favourited,
      this.language,
      this.classes,
      this.videoDownloaded});

  static CourseData fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return CourseData(
      id: json['id'],
      title: json['title'],
      short_description: json['short_description'],
      big_description: json['big_description'],
      image: json['image'],
      overview_url: json['overview_url'],
      is_free: json['is_free'],
      price: json['price'],
      is_discount: json['is_discount'],
      discount_price: json['discount_price'],
      total_enroll: json['total_enroll'],
      requirement: (null != json['requirement'])
          ? (json['requirement'].cast<String>())
          : List<String>(),
      outcome: (null != json['outcome'])
          ? (json['outcome'].cast<String>())
          : List<String>(),
      category: InstructorData.fromJson(json['category']),
      instructor: InstructorData.fromJson(json['instructor']),
      is_favourited: json['is_favourited'],
      language: json['language'],
        classes: (null != json['classes'])? (json['classes'] as List)
            .map((itemWord) => ClassData.fromJson(itemWord))
            .toList() ?? [] : List<ClassData>(),
        videoDownloaded: json['videoDownloaded']
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'short_description': short_description,
        'big_description': big_description,
        'image': image,
        'overview_url': overview_url,
        'is_free': is_free,
        'price': price,
        'is_discount': is_discount,
        'discount_price': discount_price,
        'total_enroll': total_enroll,
        'requirement': requirement,
        'outcome': outcome,
        'category': category,
        'instructor': instructor,
        'is_favourited': is_favourited,
        'language': language,
        'classes': classes,
    'videoDownloaded': videoDownloaded
      };

  String encodedJson() => json.encode(toJson());

  static CourseData decodedJson(String source) => fromJson(json.decode(source));

}
