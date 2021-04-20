import 'package:adrus/base/base_bloc.dart';
import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/responses/support_response.dart';
import 'package:adrus/data/repo/repo_home.dart';

class SupportBloc extends BaseBloc<Result<SupportResponse>> {
  HomeRepo repository;

  SupportBloc(this.repository);

  Future<void> getSupport() async {
    emit(Result.loading());
    try {
      var result = await repository.getSupport();
      emit(Result.success(result));
    } on Exception catch (e) {
      print("Login Error: ${e.toString()}");
      emit(Result.error(e.toString()));
    }
  }
}
