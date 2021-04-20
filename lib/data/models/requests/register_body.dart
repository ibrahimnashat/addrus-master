import 'dart:convert';

import 'package:adrus/base/base_body.dart';
import 'package:adrus/base/base_model.dart';


class RegisterBody extends BaseModel {
  String email;
  String password;
  String name;

  RegisterBody({this.email, this.password, this.name});

  static String getBaseBodyJson({
    String email,
    String password,
    String name
  }) {
    return BaseBody(
      RegisterBody(email: email, password: password, name: name),
    ).toJson();
  }

  @override
  RegisterBody fromJson(Map<String, dynamic> json) {
    return RegisterBody(
      email: json['email'],
      password: json['password'],
        name: json['name']
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['name'] = this.name;
    return data;
  }

  String encodedJson() => json.encode(toJson());
}
