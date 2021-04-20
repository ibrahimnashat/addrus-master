import 'package:adrus/base/base_bloc.dart';
import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/responses/login_response.dart';
import 'package:adrus/data/repo/repo_user.dart';


class LoginSocialBloc extends BaseBloc<Result<LoginResponse>> {
  UserRepo repository;

  LoginSocialBloc(this.repository);

  Future<void> handleLogin(String email, String name, String providerId) async {
    emit(Result.loading());
    try {
      var userData = await repository.handleLoginSocial(email, name, providerId);
      emit(Result.success(userData));
    } on Exception catch (e) {
      print("fetchLetterList Error: ${e.toString()}");
      emit(Result.error(e.toString()));
    }
  }
}
