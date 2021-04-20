
//doaa@mail.com - 123Doak***, all subscriped
//mahmoud@mail.com - 123Doak*** , closed
//ahmed@mail.com - 123Doak*** - subscribe_id->1
//mayar@mail.com - 123Doak*** - subscribe_id->2, closed
//countryData1@mail.com - 123Doak***


import 'dart:convert';
import '../course_data.dart';

class CourseDataResponse {
   int id;
   String date;
   CourseData course ;

  CourseDataResponse(
      {this.id,
      this.date,
      this.course,
      // this.items
      });

  static CourseDataResponse fromJson(Map<String, dynamic> json) {
    return CourseDataResponse(
      id: json['id'],
        date: json['date'],
        course: CourseData.fromJson(json['course'])
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'date': date,
        'course': course};

   String encodedJson() => json.encode(toJson());

   static CourseDataResponse decodedJson(String source) =>
       fromJson(json.decode(source));

}



