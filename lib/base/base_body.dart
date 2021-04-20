import 'dart:convert';

import 'base_model.dart';

class BaseBody<T extends BaseModel> {
  final T data;
  BaseBody(this.data);

  Map<String, dynamic> toMap() {
    return data?.toJson() ;
    //   {
    //   'data': data?.toMap(),
    // };
  }

  T fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return data.fromJson(map); //fromMap(map['data']);
  }

  String toJson() => json.encode(toMap());

  T fromJson(String source) => fromMap(json.decode(source));
}
