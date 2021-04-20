import 'package:adrus/base/base_bloc.dart';
import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/responses/my_courses_response.dart';
import 'package:adrus/data/models/responses/slider_response.dart';
import 'package:adrus/data/repo/repo_home.dart';

class MyCoursesBloc extends BaseBloc<Result<MyCoursesResponse>> {
  HomeRepo repository;

  MyCoursesBloc(this.repository);

  Future<void> getMyCourses() async {
    emit(Result.loading());
    try {
      var result = await repository.getMyCourses();
      emit(Result.success(result));
    } on Exception catch (e) {
      print("Login Error: ${e.toString()}");
      emit(Result.error(e.toString()));
    }
  }
}
