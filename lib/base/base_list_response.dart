import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'base_model.dart';

class BaseListResponse<T extends BaseModel> {
  final int statusCode;
  final String message;
  final List<T> list;
  BaseListResponse({
    this.statusCode,
    this.message,
    this.list,
  });

  Map<String, dynamic> toMap() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': list?.map((x) => x?.toJson())?.toList(),
    };
  }

  static BaseListResponse fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return BaseListResponse(
      statusCode: map['statusCode']?.toInt() ?? 0,
      message: map['message'] ?? '',
      list: List<BaseModel>.from(
          map['data']?.map((x) => x.decodedJson()) ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  static BaseListResponse fromJson(String source) =>
      fromMap(json.decode(source));

  @override
  String toString() =>
      'BaseListResponse(statusCode: $statusCode, message: $message, data: $list)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is BaseListResponse &&
        o.statusCode == statusCode &&
        o.message == message &&
        listEquals(o.list, list);
  }
}
