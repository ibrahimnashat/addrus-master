import 'dart:convert';

import 'package:adrus/base/base_body.dart';
import 'package:adrus/base/base_model.dart';

class LoginBody extends BaseModel {
  String email;
  String password;
  String provider_id;
  String name;
  String token;

  LoginBody(
      {this.email, this.password, this.provider_id, this.name, this.token});

  static String getBaseBodyJson(
      {String email,
      String password,
      String provider_id,
      String name,
      String token}) {
    return BaseBody(
      LoginBody(
          email: email,
          password: password,
          provider_id: provider_id,
          name: name,
          token: token),
    ).toJson();
  }

  @override
  LoginBody fromJson(Map<String, dynamic> json) {
    return LoginBody(
        email: json['email'],
        password: json['password'],
        provider_id: json['provider_id'],
        name: json['name'],
        token: json['token']);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['provider_id'] = this.provider_id;
    data['name'] = this.name;
    data['token'] = this.token;
    return data;
  }

  String encodedJson() => json.encode(toJson());
}
