import 'package:adrus/base/base_bloc.dart';
import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/responses/categories_response.dart';
import 'package:adrus/data/models/responses/login_response.dart';
import 'package:adrus/data/models/responses/status_response.dart';
import 'package:adrus/data/repo/repo_home.dart';
import 'package:adrus/data/repo/repo_home.dart';
import 'package:adrus/data/repo/repo_user.dart';


class LogoutBloc extends BaseBloc<Result<StatusResponse>> {
  UserRepo repository;

  LogoutBloc(this.repository);

  Future<void> handleLogout() async {
    emit(Result.loading());
    try {
      var result = await repository.handleLogout();
      emit(Result.success(result));
    } on Exception catch (e) {
      print("Login Error: ${e.toString()}");
      emit(Result.error(e.toString()));
    }
  }
}
