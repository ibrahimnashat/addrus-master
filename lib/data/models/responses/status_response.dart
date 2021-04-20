//0109988745 - 123123

import 'dart:convert';

import '../user_data.dart';

//0109988745 - 123123

class StatusResponse {
  int status;
  String message;
  String error;

  StatusResponse({
    this.status,
    this.message,
    this.error,
  });

  static StatusResponse fromJson(Map<String, dynamic> json) {
    return StatusResponse(
      status: json['status'],
      message: json['message'],
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
        'message': message,
        'error': error,
      };

  String encodedJson() => json.encode(toJson());

  static StatusResponse decodedJson(String source) =>
      fromJson(json.decode(source));
}
