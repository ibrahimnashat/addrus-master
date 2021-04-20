import 'package:adrus/data/repo/repo_home.dart';
import 'package:adrus/data/repo/repo_user.dart';
import 'package:adrus/ui/bloc/bloc_add_favorite.dart';
import 'package:adrus/ui/bloc/bloc_answer_question.dart';
import 'package:adrus/ui/bloc/bloc_categories.dart';
import 'package:adrus/ui/bloc/bloc_edit_profile.dart';
import 'package:adrus/ui/bloc/bloc_forget_password.dart';
import 'package:adrus/ui/bloc/bloc_login.dart';
import 'package:adrus/ui/bloc/bloc_login_social.dart';
import 'package:adrus/ui/bloc/bloc_logout.dart';
import 'package:adrus/ui/bloc/bloc_my_courses.dart';
import 'package:adrus/ui/bloc/bloc_register.dart';
import 'package:adrus/ui/bloc/bloc_remove_favorite.dart';
import 'package:adrus/ui/bloc/bloc_slider.dart';
import 'package:adrus/ui/bloc/bloc_support.dart';
import 'package:adrus/utils/api_utils.dart';
import 'package:adrus/utils/app_utils.dart';
import 'package:adrus/utils/session_manager.dart';
import 'package:adrus/widgets/components.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! init core
  sl.registerLazySingleton(() => SessionManager(sl()));
  sl.registerLazySingleton(() => ApiUtils(sl()));
  //! init external
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => prefs);
  sl.registerLazySingleton(() => Client());

  //
  sl.registerLazySingleton(() => Components());
  sl.registerLazySingleton(() => AppUtils());

  //! init features
  injectLogin();
  injectHome();
}

void injectLogin() {
  sl.registerFactory(() => LoginBloc(sl()));
  sl.registerFactory(() => LoginSocialBloc(sl()));
  sl.registerFactory(() => RegisterBloc(sl()));
  sl.registerFactory(() => ForgetPasswordBloc(sl()));
  sl.registerFactory(() => LogoutBloc(sl()));
  sl.registerFactory(() => EditProfileBloc(sl()));
  sl.registerLazySingleton(() => UserRepo(sl(), sl()));
}

void injectHome() {
  sl.registerFactory(() => SliderBloc(sl()));
  sl.registerFactory(() => MyCoursesBloc(sl()));
  sl.registerFactory(() => AddFavoriteBloc(sl()));
  sl.registerFactory(() => RemoveFavoriteBloc(sl()));
  sl.registerFactory(() => SupportBloc(sl()));
  sl.registerFactory(() => AnswerQuestionBloc(sl()));
  sl.registerLazySingleton(() => HomeRepo(sl(), sl()));
}
