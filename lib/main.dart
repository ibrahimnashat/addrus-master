import 'dart:async';
import 'package:adrus/ui/bloc/bloc_login.dart';
import 'package:adrus/ui/bloc/bloc_login_social.dart';
import 'package:adrus/ui/screens/opening_screen.dart';
import 'package:adrus/utils/helpers/app_constants.dart';
import 'package:adrus/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:adrus/di/injection_container.dart' as di;
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'base/result.dart';
import 'data/models/responses/login_response.dart';
import 'di/injection_container.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/login_screen.dart';
import 'utils/app_utils.dart';
import 'utils/helpers/app_themes.dart';
import 'utils/helpers/user_constants.dart';
import 'utils/session_manager.dart';
import 'utils/size_config.dart';
import 'widgets/splah_bkg_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(ProviderScope(child: Phoenix(child: MyApp())));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: AppConstants.APP_NAME,
              home: AppScreen(),
              theme: AppTheme.myAppTheme,
            );
          },
        );
      },
    );
  }
}

class AppScreen extends StatefulWidget {
  final String locale;

  AppScreen({
    Key key,
    this.locale,
  }) : super(key: key);

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  final SessionManager sessionManager = sl<SessionManager>();
  final LoginBloc _loginBloc = sl<LoginBloc>();
  final LoginSocialBloc _loginSocialBloc = sl<LoginSocialBloc>();
  final Components components = sl<Components>();

  @override
  void initState() {
    _loginBloc.mainStream.listen(_observeLogin);
    _loginSocialBloc.mainStream.listen(_observeLogin);

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AppUtils.checkConnectivity().then((isConnected) {
        print("isConnected: $isConnected");
        // if (isConnected) {
        String openingScreenSeen =
            sessionManager.getValue(UserConstants.OPENING_SCREEN_SEEN);
        print("openingScreenSeen: $openingScreenSeen");

        Timer(Duration(seconds: 4), () {
          if (openingScreenSeen == "true") {
            print("# step 1");
            String logged = sessionManager.getValue(UserConstants.USER_LOGGED);

            if (logged.isNotEmpty) {
              //logged before
              print("# step 2");
              if (isConnected) {
                print("# step 3");
                String phone =
                    sessionManager.getValue(UserConstants.LOGIN_EMAIL);
                String password =
                    sessionManager.getValue(UserConstants.LOGIN_PASSWORD);

                String providerId =
                    sessionManager.getValue(UserConstants.PROVIDER_ID);
                String providerName =
                    sessionManager.getValue(UserConstants.PROVIDER_NAME);

                if (null != providerId && providerId.isNotEmpty) {
                  _loginSocialBloc.handleLogin(phone, providerName, providerId);
                } else {
                  _loginBloc.handleLogin(phone, password);
                }
              } else {
                print("# step 4");
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen()));
              }
            } else {
              print("# step 5");
              //not logged
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => OpeningScreen()));
            }
          } else {
            print("# step 6");
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => OpeningScreen()));
          }
        });
        // } else {
        //   components.displayDialog(context, "تنبيه",
        //       "لا يوجد اتصال بالانترنت افحص اتصالك بالشبكة وحاول مرة اخرى");
        // }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashBackgroudWidget();
  }

//  ----------
  void _observeLogin(Result<LoginResponse> result) {
    if (result is SuccessResult) {
      sessionManager.setUser(result.getSuccessData());
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
    } else if (result is ErrorResult) {
      print("result: ${result.getErrorMessage()}");
      if (result.getErrorMessage().contains("101")) {
        //offline
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen()));
      }
    }
  }
}
