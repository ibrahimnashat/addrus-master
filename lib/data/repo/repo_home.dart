import 'package:adrus/data/models/Answer.dart';
import 'package:adrus/data/models/requests/answer_question.dart';
import 'package:adrus/data/models/requests/favorite_body.dart';
import 'package:adrus/data/models/responses/answer_question_response.dart';
import 'package:adrus/data/models/responses/categories_response.dart';
import 'package:adrus/data/models/responses/my_courses_response.dart';
import 'package:adrus/data/models/responses/slider_response.dart';
import 'package:adrus/data/models/responses/status_response.dart';
import 'package:adrus/data/models/responses/support_response.dart';
import 'package:adrus/utils/api_utils.dart';
import 'package:adrus/utils/helpers/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomeRepo {
  final Client client;
  final ApiUtils apiUtils;
  HomeRepo(this.client, this.apiUtils);

  Future<SliderResponse> getSlider() async {
    final url = Urls.HOME_SLIDER;

    print("$url headers = ${apiUtils.headers.toString()}");
    final response =
        await client.get(Uri.parse(url), headers: apiUtils.headers);
    print('request.url:: ${response.statusCode} - ${response.request.url}');
    print('response.body:: ${response.body.toString()}');
    if (response.statusCode == 200) {
      return SliderResponse.decodedJson(response.body);
    } else {
      throw Exception(response.body.toString());
    }
  }

  Future<CategoriesResponse> getCategories() async {
    final url = Urls.CATEGORIES;

    print("$url headers = ${apiUtils.headers.toString()}");
    final response =
        await client.get(Uri.parse(url), headers: apiUtils.headers);
    print('request.url:: ${response.statusCode} - ${response.request.url}');
    print('response.body:: ${response.body.toString()}');
    if (response.statusCode == 200) {
      return CategoriesResponse.decodedJson(response.body);
    } else {
      throw Exception(response.body.toString());
    }
  }

  Future<MyCoursesResponse> getMyCourses() async {
    final url = Urls.ALL_COURSES;

    print("$url headers = ${apiUtils.headers.toString()}");
    final response =
        await client.get(Uri.parse(url), headers: apiUtils.headers);
    print('request.url:: ${response.statusCode} - ${response.request.url}');
    debugPrint('Courses Res:: ${response.body.toString()}');
    if (response.statusCode == 200) {
      return MyCoursesResponse.decodedJson(response.body);
    } else {
      throw Exception(response.body.toString());
    }
  }

  Future<StatusResponse> addFavorite(int courseId) async {
    final url = Urls.ADD_FAVORITE;
    var body = FavoriteBody.getBaseBodyJson(courseId: "$courseId");
    debugPrint("$url headers = ${apiUtils.headers.toString()}\nbody = $body");
    final response = await client.post(Uri.parse(url),
        body: body, headers: apiUtils.headers);
    debugPrint(
        'request.url:: ${response.statusCode} - ${response.request.url}');
    debugPrint('response.body:: ${response.body.toString()}');
    if (response.statusCode == 200) {
      return StatusResponse.decodedJson(response.body);
    } else {
      throw Exception(response.body.toString());
    }
  }

  Future<StatusResponse> removeFavorite(int courseId) async {
    final url = "${Urls.DELETE_FAVORITE}$courseId";

    print("$url headers = ${apiUtils.headers.toString()}");
    final response =
        await client.get(Uri.parse(url), headers: apiUtils.headers);
    print('request.url:: ${response.statusCode} - ${response.request.url}');
    print('response.body:: ${response.body.toString()}');
    if (response.statusCode == 200) {
      return StatusResponse.decodedJson(response.body);
    } else {
      throw Exception(response.body.toString());
    }
  }

  Future<SupportResponse> getSupport() async {
    final url = Urls.SUPPORT;

    print("$url headers = ${apiUtils.headers.toString()}");
    final response =
        await client.get(Uri.parse(url), headers: apiUtils.headers);
    print('request.url:: ${response.statusCode} - ${response.request.url}');
    print('response.body:: ${response.body.toString()}');
    if (response.statusCode == 200) {
      return SupportResponse.decodedJson(response.body);
    } else {
      throw Exception(response.body.toString());
    }
  }

  Future<AnswerQuestionResponse> answerQuestion(
    int quiz_id,
    int content_id,
    List<Answer> question,
    int exam_minutes,
    int exam_seconds,
  ) async {
    final url = Urls.ANSWER_QUESTION;
    var body = AnswerQuestion.getBaseBodyJson(
        quiz_id: quiz_id,
        content_id: content_id,
        question: question,
        exam_minutes: exam_minutes,
        exam_seconds: exam_seconds);
    debugPrint("$url headers = ${apiUtils.headers.toString()}\nbody = $body");
    final response = await client.post(Uri.parse(url),
        body: body, headers: apiUtils.headers);
    debugPrint(
        'request.url:: ${response.statusCode} - ${response.request.url}');
    debugPrint('response.body:: ${response.body.toString()}');
    if (response.statusCode == 200) {
      return AnswerQuestionResponse.decodedJson(response.body);
    } else {
      throw Exception(response.body.toString());
    }
  }
}
