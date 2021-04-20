import 'dart:convert';

class ApiResponse {
  final int statusCode;
  final String message;
  final Map<String, dynamic> data;
  ApiResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data,
    };
  }

  static ApiResponse fromMap<T>(Map<String, dynamic> map) {
    if (map == null) return null;
    return ApiResponse(
      statusCode: map['statusCode']?.toInt() ?? 0,
      message: map['message'] ?? '',
      data: map['data'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ApiResponse.fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() =>
      'ApiResponse(statusCode: $statusCode, message: $message, data: $data)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is ApiResponse &&
        o.statusCode == statusCode &&
        o.message == message &&
        o.data == data;
  }
}
