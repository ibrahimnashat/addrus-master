import 'dart:io';

import 'package:adrus/base/base_bloc.dart';
import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/responses/login_response.dart';
import 'package:adrus/data/repo/repo_user.dart';


class RegisterBloc extends BaseBloc<Result<LoginResponse>> {
  UserRepo repository;

  RegisterBloc(this.repository);

  Future<void> handleRegister(String name, String email, String password, File imageFile) async {
    emit(Result.loading());
    try {
      var userData = await repository.handleRegister(name, email, password, imageFile);
      emit(Result.success(userData));
    } on Exception catch (e) {
      print("fetchLetterList Error: ${e.toString()}");
      emit(Result.error(e.toString()));
    }
  }
}
