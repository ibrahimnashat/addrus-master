import 'dart:convert';

import 'package:adrus/base/base_body.dart';
import 'package:adrus/base/base_model.dart';

class FavoriteBody extends BaseModel {
  String courseId;

  FavoriteBody({this.courseId});

  static String getBaseBodyJson({
    String courseId,
  }) {
    return BaseBody(
      FavoriteBody(courseId: courseId),
    ).toJson();
  }

  @override
  FavoriteBody fromJson(Map<String, dynamic> json) {
    return FavoriteBody(
      courseId: json['courseId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['courseId'] = this.courseId;
    return data;
  }

  String encodedJson() => json.encode(toJson());
}
