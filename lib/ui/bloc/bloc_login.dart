import 'package:adrus/base/base_bloc.dart';
import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/responses/login_response.dart';
import 'package:adrus/data/repo/repo_user.dart';
import 'package:fcm_config/fcm_config.dart';

class LoginBloc extends BaseBloc<Result<LoginResponse>> {
  UserRepo repository;

  LoginBloc(this.repository);

  Future<void> handleLogin(String email, String password) async {
    emit(Result.loading());
    try {
      final token = await FCMConfig().getToken();
      var userData = await repository.handleLogin(email, password, token);
      emit(Result.success(userData));
    } on Exception catch (e) {
      print("fetchLetterList Error: ${e.toString()}");
      emit(Result.error("عفواً، هذا الحساب مسجل علي جهاز آخر"));
    }
  }
}
