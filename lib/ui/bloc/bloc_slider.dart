import 'dart:convert';

import 'package:adrus/base/base_bloc.dart';
import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/responses/slider_response.dart';
import 'package:adrus/data/models/responses/status_response.dart';
import 'package:adrus/data/repo/repo_home.dart';

class SliderBloc extends BaseBloc<Result<SliderResponse>> {
  HomeRepo repository;

  SliderBloc(this.repository);

  Future<void> getSlider() async {
    emit(Result.loading());
    try {
      var result = await repository.getSlider();
      emit(Result.success(result));
    } on Exception catch (e) {
      print("Login Error: ${e.toString()}");
      emit(Result.error(e.toString()));
    }
  }
}
