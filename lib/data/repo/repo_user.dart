import 'dart:convert';
import 'dart:io';
import 'package:adrus/data/models/requests/login_body.dart';
import 'package:adrus/data/models/responses/status_response.dart';
import 'package:http/http.dart' as http;
import 'package:adrus/data/models/requests/register_body.dart';
import 'package:adrus/data/models/responses/login_response.dart';
import 'package:adrus/utils/api_utils.dart';
import 'package:adrus/utils/helpers/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UserRepo {
  final Client client;
  final ApiUtils apiUtils;
  UserRepo(this.client, this.apiUtils);

  Future<LoginResponse> handleLogin(String email, String password) async {
    final url = Urls.LOGIN;
    var body = LoginBody.getBaseBodyJson(email: email, password: password);
    debugPrint("$url headers = ${apiUtils.headers.toString()}\nbody = $body");
    final response = await client.post(Uri.parse(url),
        body: body, headers: apiUtils.headers);
    debugPrint(
        'request.url:: ${response.statusCode} - ${response.request.url}');
    debugPrint('response.body:: ${response.body.toString()}');
    if (response.statusCode == 200) {
      return LoginResponse.decodedJson(response.body);
    } else {
      throw Exception("بيانات المدخلة غير صحيحة");
    }
  }

  Future<LoginResponse> handleLoginSocial(
      String email, String name, String ProviderId) async {
    final url = Urls.LOGIN;
    var body = LoginBody.getBaseBodyJson(
        email: email, name: name, provider_id: ProviderId);
    debugPrint("$url headers = ${apiUtils.headers.toString()}\nbody = $body");
    final response = await client.post(Uri.parse(url),
        body: body, headers: apiUtils.headers);
    debugPrint(
        'request.url:: ${response.statusCode} - ${response.request.url}');
    debugPrint('response.body:: ${response.body.toString()}');
    if (response.statusCode == 200) {
      return LoginResponse.decodedJson(response.body);
    } else {
      throw Exception(response.body.toString());
    }
  }

  Future<LoginResponse> handleRegister(
      String name, String email, String password, File imageFile) async {
    var uri = Uri.parse(Urls.REGISTER);

    var request = new http.MultipartRequest("POST", uri);
    if (null != imageFile) {
      var multipartFile =
          await http.MultipartFile.fromPath("image", imageFile.path);
      request.files.add(multipartFile);
    }

    request.fields["name"] = name;
    request.fields["email"] = email;
    request.fields["password"] = password;
    request.headers.addAll(apiUtils.headers);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    debugPrint('request.url:: ${response.statusCode} - ${response.request}');
    debugPrint('response.body:: ${response.body.toString()}');

    if (streamedResponse.statusCode == 200) {
      return LoginResponse.decodedJson(response.body);
    } else {
      throw Exception(response.body.toString());
    }
  }

  Future<LoginResponse> editProfile(
      String name, String password, File imageFile) async {
    var uri = Uri.parse(Urls.EDIT_PROFILE);

    var request = new http.MultipartRequest("POST", uri);
    if (null != imageFile) {
      var multipartFile =
          await http.MultipartFile.fromPath("image", imageFile.path);
      request.files.add(multipartFile);
    }

    request.fields["name"] = name;
    // request.fields["email"] = email;
    request.fields["password"] = password;
    request.headers.addAll(apiUtils.headers);

    print("request.headers: ${request.headers}");

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    debugPrint('request.url:: ${response.statusCode} - ${response.request}');
    debugPrint('response.body:: ${response.body.toString()}');

    if (streamedResponse.statusCode == 200) {
      return LoginResponse.decodedJson(response.body);
    } else {
      throw Exception(response.body.toString());
    }
  }

  Future<LoginResponse> handleForgetPassword(String email) async {
    final url = Urls.FORGET_PASSWORD;
    var body = RegisterBody.getBaseBodyJson(email: email);
    debugPrint("$url headers = ${apiUtils.headers.toString()}\nbody = $body");
    final response = await client.post(Uri.parse(url),
        body: body, headers: apiUtils.headers);
    debugPrint(
        'request.url:: ${response.statusCode} - ${response.request.url}');
    debugPrint('response.body:: ${response.body.toString()}');
    if (response.statusCode == 200) {
      return LoginResponse.decodedJson(response.body);
    } else {
      throw Exception(response.body.toString());
    }
  }

  Future<StatusResponse> handleLogout() async {
    final url = Urls.LOGOUT;
    debugPrint("$url headers = ${apiUtils.headers.toString()}");
    final response =
        await client.get(Uri.parse(url), headers: apiUtils.headers);
    debugPrint(
        'request.url:: ${response.statusCode} - ${response.request.url}');
    debugPrint('response.body:: ${response.body.toString()}');
    if (response.statusCode == 200) {
      return StatusResponse.decodedJson(response.body);
    } else {
      throw Exception(response.body.toString());
    }
  }
}
