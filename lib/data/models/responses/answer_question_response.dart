import 'dart:convert';
import '../state_data.dart';

class AnswerQuestionResponse {
  int status;
   String message;
   String error;
   String why_fail;
   StateData state;

  AnswerQuestionResponse(
      {
        this.status,
      this.message,
        this.error,
      this.why_fail,
      this.state});

  static AnswerQuestionResponse fromJson(Map<String, dynamic> json) {
    return AnswerQuestionResponse(
      status: json['status'],
        message: json['message'],
      error: json['error'],
        why_fail: json['why_fail'],
        state: StateData.fromJson(json['state']),
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'status': status,
        'message': message,
        'error': error,
        'why_fail': why_fail,
        'state': state
      };

   String encodedJson() => json.encode(toJson());

   static AnswerQuestionResponse decodedJson(String source) =>
       fromJson(json.decode(source));

}



