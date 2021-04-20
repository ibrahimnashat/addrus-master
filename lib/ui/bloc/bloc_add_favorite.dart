import 'package:adrus/base/base_bloc.dart';
import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/responses/status_response.dart';
import 'package:adrus/data/repo/repo_home.dart';



class AddFavoriteBloc extends BaseBloc<Result<StatusResponse>> {
  HomeRepo repository;

  AddFavoriteBloc(this.repository);

  Future<void> addFavorite(int courseId) async {
    emit(Result.loading());
    try {
      var result = await repository.addFavorite(courseId);
      emit(Result.success(result));
    } on Exception catch (e) {
      print("Login Error: ${e.toString()}");
      emit(Result.error(e.toString()));
    }
  }
}
