import 'dart:async';
import 'dart:io';
import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/responses/login_response.dart';
import 'package:adrus/data/models/responses/status_response.dart';
import 'package:adrus/di/injection_container.dart';
import 'package:adrus/ui/bloc/bloc_login.dart';
import 'package:adrus/ui/bloc/bloc_login_social.dart';
import 'package:adrus/ui/screens/welcome_screen.dart';
import 'package:adrus/utils/api_utils.dart';
import 'package:adrus/utils/helpers/app_assets.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/login_type.dart';
import 'package:adrus/utils/helpers/message.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/helpers/user_constants.dart';
import 'package:adrus/utils/session_manager.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:adrus/widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:adrus/main.dart';

class SocialButtons extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<SocialButtons> {
  final SessionManager sessionManager = sl<SessionManager>();
  final Components components = sl<Components>();
  final ApiUtils apiUtils = sl<ApiUtils>();

  final LoginSocialBloc _loginBloc = sl<LoginSocialBloc>();
  bool isLoading = true;
  String countryId;
  String loginType;

  @override
  void initState() {
    _loginBloc.mainStream.listen(_observeLogin);
    super.initState();
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  @override
  Widget build(BuildContext context) {
    // AppleSignIn.onCredentialRevoked.listen((_) {
    //   print("Credentials revoked");
    // });

    return allButtons(context);
  }

  //------------
  Widget allButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 5 * SizeConfig.heightMultiplier,
              width: 5 * SizeConfig.heightMultiplier,
              child: InkWell(
                onTap: () {
                  handleFacebookLogin();
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.BLUE_FACEBOOK,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 1 * SizeConfig.heightMultiplier),
                    alignment: Alignment.center,
                    child: Image.asset(
                      AppAssets.IC_FACEBOOK,
                      width: 2 * SizeConfig.heightMultiplier,
                      height: 2 * SizeConfig.heightMultiplier,
                      color: Colors.white,
                    )),
              ),
            ),
            SizedBox(
              width: 2 * SizeConfig.heightMultiplier,
            ),
            SizedBox(
              height: 5 * SizeConfig.heightMultiplier,
              width: 5 * SizeConfig.heightMultiplier,
              child: InkWell(
                onTap: () {
                  handleGoogleLogin();
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: AppColors.RED_GOOGLE, shape: BoxShape.circle),
                    padding: EdgeInsets.symmetric(
                        horizontal: 1 * SizeConfig.heightMultiplier),
                    alignment: Alignment.center,
                    child: Image.asset(
                      AppAssets.IC_GOOGLE,
                      width: 3 * SizeConfig.heightMultiplier,
                      height: 3 * SizeConfig.heightMultiplier,
                      color: Colors.white,
                    )),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 2 * SizeConfig.heightMultiplier,
        ),
        (Platform.isIOS)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      height: 5 * SizeConfig.heightMultiplier,
                      decoration: AppStyles.decorationRoundedColoredBorder(
                          Colors.white, 1.1, Colors.black, 1),
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.5 * SizeConfig.heightMultiplier),
                      alignment: Alignment.center,
                      // child: AppleSignInButton(
                      //   onPressed: () {
                      //     handleAppleLogIn(context);
                      //   },
                      // ),
                    ),
                  ),
                ],
              )
            : Center()
      ],
    );
  }

  // void handleAppleLogIn(BuildContext context) async {
  //   final Components components = sl<Components>();
  //
  //   if (!await AppleSignIn.isAvailable()) {
  //     components.displayToast(
  //         context, "Apple sign in not available on this device");
  //     return null; //Break from the program
  //   }
  //
  //   final AuthorizationResult result = await AppleSignIn.performRequests([
  //     AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  //   ]);
  //
  //   switch (result.status) {
  //     case AuthorizationStatus.authorized:
  //       print("userId : ${result.credential.user}");
  //       print(
  //           "credential : ${result.credential.email} - ${result.credential.fullName.givenName} - "
  //           "${result.credential.fullName.nameSuffix} - ${result.credential.identityToken} - ${result.credential.authorizationCode}");
  //       setState(() {
  //         isLoading = true;
  //         loginType = LoginType.APPLE;
  //       });
  //
  //       String name =
  //           "${result.credential.fullName.givenName} ${result.credential.fullName.familyName}";
  //       print("name: $name");
  //       // _loginBloc.handleLogin(result.credential.email, null, fcmToken,
  //       //     countryId, LoginType.FACEBOOK, result.credential.user, name, null);
  //
  //       break;
  //
  //     case AuthorizationStatus.error:
  //       print("Sign in failed: ${result.error.localizedDescription}");
  //       break;
  //
  //     case AuthorizationStatus.cancelled:
  //       print('User cancelled');
  //       break;
  //   }
  // }

  handleFacebookLogin() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print("Facebook token:: ${result.accessToken.token}");
        final key = result.accessToken.token;
        final graphResponse = await http.get(Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$key'));
        final profile = json.decode(graphResponse.body);
        print(
            "Facebook profile:: ${profile['id']} - ${profile['email']} - ${profile['name']}}");

        setState(() {
          isLoading = true;
          loginType = LoginType.FACEBOOK;
        });

        sessionManager.setValue(UserConstants.LOGIN_EMAIL, profile['email']);
        sessionManager.setValue(UserConstants.PROVIDER_ID, profile['id']);
        sessionManager.setValue(UserConstants.PROVIDER_NAME, profile['name']);

        _loginBloc.handleLogin(
            profile['email'], profile['name'], profile['id']);

        FacebookLogin().logOut(); //sign out after login to forget this user
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("Facebook canceled");
        break;
      case FacebookLoginStatus.error:
        print("Facebook error");
        break;
    }
  }

  handleGoogleLogin() async {
    await _googleSignIn.signIn().then((result) {
      print(result.photoUrl);
      result.authentication.then((googleKey) {
        print("accessToken:: ${googleKey.accessToken}");
        print("idToken:: ${googleKey.idToken}");
        print("displayName:: ${_googleSignIn.currentUser.displayName}");
        print("email: ${_googleSignIn.currentUser.email}");
        print("ID: ${_googleSignIn.currentUser.id}");

        setState(() {
          isLoading = true;
          loginType = LoginType.GOOGLE;
        });

        sessionManager.setValue(
            UserConstants.LOGIN_EMAIL, _googleSignIn.currentUser.email);
        sessionManager.setValue(
            UserConstants.PROVIDER_ID, _googleSignIn.currentUser.id);
        sessionManager.setValue(
            UserConstants.PROVIDER_NAME, _googleSignIn.currentUser.displayName);

        _loginBloc.handleLogin(
            _googleSignIn.currentUser.email,
            _googleSignIn.currentUser.displayName,
            _googleSignIn.currentUser.id);

        _googleSignIn.signOut(); //sign out after login to forget this user
      }).catchError((err) {
        print('inner error:: ${err.toString()}');
      });
    }).catchError((err) {
      print('error occured:: ${err.toString()}');
    });
  }

  //---------------
  void _observeLogin(Result<LoginResponse> result) {
    print("Result Login:: $result");
    if (result is SuccessResult) {
      if (null != result.getSuccessData().user ||
          null != result.getSuccessData().access_token) {
        print("Token length: ${result.getSuccessData().access_token.length}");
        sessionManager.setUser(result.getSuccessData());

        Timer(Duration(seconds: 1), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => WelcomeScreen()));
        });
      } else if (null != result.getSuccessData().message) {
        components.displayDialog(
            context, Message.ERROR_HAPPENED, result.getSuccessData().message);
      }
    } else if (result is ErrorResult) {
      StatusResponse error = StatusResponse.decodedJson(
          result.getErrorMessage().replaceAll("Exception:", ""));
      if (error.status == 401) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          sessionManager.deleteUser();
          Phoenix.rebirth(context);
        });
      } else {
        components.displayDialog(
            context, Message.ERROR_HAPPENED, result.getErrorMessage());
      }
    }

    setState(() {
      isLoading = false;
    });
  }
}
