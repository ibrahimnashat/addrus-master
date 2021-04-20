import 'package:adrus/base/base_bloc.dart';
import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/responses/categories_response.dart';
import 'package:adrus/data/repo/repo_home.dart';


class CategoriesBloc extends BaseBloc<Result<CategoriesResponse>> {
  HomeRepo repository;

  CategoriesBloc(this.repository);

  Future<void> getCategories() async {
    emit(Result.loading());
    try {
      var result = await repository.getCategories();
      emit(Result.success(result));
    } on Exception catch (e) {
      print("Login Error: ${e.toString()}");
      emit(Result.error(e.toString()));
    }
  }
}
