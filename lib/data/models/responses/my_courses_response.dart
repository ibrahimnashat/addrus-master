
//doaa@mail.com - 123Doak***, all subscriped
//mahmoud@mail.com - 123Doak*** , closed
//ahmed@mail.com - 123Doak*** - subscribe_id->1
//mayar@mail.com - 123Doak*** - subscribe_id->2, closed
//countryData1@mail.com - 123Doak***


import 'dart:convert';

import '../course_data.dart';
import '../slider_data.dart';
import 'course_data_response.dart';

class MyCoursesResponse {
   int status;
   String msg;
   List<CourseData> data ;

  MyCoursesResponse(
      {this.status,
      this.msg,
      this.data,
      // this.items
      });

  static MyCoursesResponse fromJson(Map<String, dynamic> json) {
    return MyCoursesResponse(
      status: json['status'],
        msg: json['msg'],
        data: (null != json['data'])? (json['data'] as List)
            .map((itemWord) => CourseData.fromJson(itemWord))
            .toList() ?? [] : List<CourseData>()
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'status': status,
        'msg': msg,
        'data': data};

   String encodedJson() => json.encode(toJson());

   static MyCoursesResponse decodedJson(String source) =>
       fromJson(json.decode(source));

}



