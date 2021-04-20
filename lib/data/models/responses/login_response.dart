
//doaa.alkasaby@gmail.com","password":"Doak123*


import 'dart:convert';

import '../user_data.dart';

class LoginResponse {
  int status;
   String message;
   String error;
   String access_token;
   UserData user;

  LoginResponse(
      {
        this.status,
      this.message,
        this.error,
      this.access_token,
      this.user});

  static LoginResponse fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
        message: json['message'],
      error: json['error'],
        access_token: json['access_token'],
        user: UserData.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'status': status,
        'message': message,
        'error': error,
        'access_token': access_token,
        'user': user
      };

   String encodedJson() => json.encode(toJson());

   static LoginResponse decodedJson(String source) =>
       fromJson(json.decode(source));

}



