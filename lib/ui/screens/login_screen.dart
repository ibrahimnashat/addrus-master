import 'dart:async';
import 'package:flutter/material.dart';
import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/responses/login_response.dart';
import 'package:adrus/di/injection_container.dart';
import 'package:adrus/ui/bloc/bloc_login.dart';
import 'package:adrus/ui/elements/login_header.dart';
import 'package:adrus/ui/elements/social_buttons.dart';
import 'package:adrus/ui/screens/forget_password_screen.dart';
import 'package:adrus/ui/screens/welcome_screen.dart';
import 'package:adrus/utils/helpers/app_assets.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/message.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/helpers/user_constants.dart';
import 'package:adrus/utils/session_manager.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:adrus/widgets/components.dart';
import 'package:adrus/widgets/error_label.dart';
import 'package:adrus/widgets/loading_indicator.dart';
import 'package:adrus/widgets/my_button.dart';
import 'package:adrus/widgets/my_text_field.dart';
import 'package:adrus/main.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScreenState();
  }
}

class ScreenState extends State<LoginScreen> {
  SessionManager sessionManager = sl<SessionManager>();
  final Components components = sl<Components>();
  final LoginBloc _loginBloc = sl<LoginBloc>();

  String email, password;
  String emailError, passwordError;
  bool isLoading = false;

  @override
  void initState() {
    _loginBloc.mainStream.listen(_observeLogin);
    super.initState();
    sessionManager.setValue(UserConstants.OPENING_SCREEN_SEEN, "true");
  }

  @override
  void dispose() {
    // _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (scaffoldContext) => Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: [
                  LoginHeader(),
                  ListView(
                    padding: AppStyles.paddingAll(
                        5, 5, 5, MediaQuery.of(context).viewInsets.bottom),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Text(
                        "اسم المستخدم",
                        textAlign: TextAlign.right,
                        style: AppTextStyles.textStyle(
                            15, AppColors.BLUE_MED, FontWeight.w600),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MyTextField(
                              hint: "",
                              hitColor: AppColors.BLUE_MED,
                              textColor: AppColors.BLUE_MED,
                              fillColor: Colors.black,
                              borderColor: AppColors.BLUE_MED,
                              defaultBorderColor: AppColors.BLUE_MED,
                              linearBottomBorder: true,
                              borderRadius: 0,
                              elevation: 0,
                              textDirection: TextDirection.ltr,
                              onValueChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 2 * SizeConfig.heightMultiplier,
                          ),
                          Image.asset(
                            AppAssets.IC_USER,
                            width: 3.2 * SizeConfig.heightMultiplier,
                            height: 3.2 * SizeConfig.heightMultiplier,
                            color: AppColors.YELLOW,
                          ),
                        ],
                      ),
                      ErrorLabel(msg: emailError),
                      SizedBox(
                        height: 3 * SizeConfig.heightMultiplier,
                      ),
                      Text(
                        "كلمة المرور",
                        textAlign: TextAlign.right,
                        style: AppTextStyles.textStyle(
                            15, AppColors.BLUE_MED, FontWeight.w600),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MyTextField(
                              hint: "",
                              hitColor: AppColors.BLUE_MED,
                              textColor: AppColors.BLUE_MED,
                              fillColor: Colors.black,
                              borderColor: AppColors.BLUE_MED,
                              defaultBorderColor: AppColors.BLUE_MED,
                              linearBottomBorder: true,
                              borderRadius: 0,
                              elevation: 0,
                              secureText: true,
                              textDirection: TextDirection.ltr,
                              onValueChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 2 * SizeConfig.heightMultiplier,
                          ),
                          Image.asset(
                            AppAssets.IC_LOCK,
                            width: 3.2 * SizeConfig.heightMultiplier,
                            height: 3.2 * SizeConfig.heightMultiplier,
                            color: AppColors.YELLOW,
                          ),
                        ],
                      ),
                      ErrorLabel(msg: passwordError),
                      SizedBox(
                        height: 5 * SizeConfig.heightMultiplier,
                      ),
                      MyButton(
                        title: "تسجيل الدخول",
                        bkgColor: AppColors.BLUE_MED,
                        paddingValue: 2,
                        showShadow: false,
                        width: double.infinity,
                        fontWight: FontWeight.bold,
                        onTap: () {
                          if (!isLoading) {
                            if (checkValidation()) {
                              setState(() {
                                isLoading = true;
                              });
                              Timer(Duration(seconds: 1), () {
                                _loginBloc.handleLogin(email, password);
                              });
                            }
                          } else {
                            components.displayToast(context,
                                "انتظر حتى الانتهاء من العملية الحالية ...");
                          }
                        },
                      ),
                      SizedBox(
                        height: 3 * SizeConfig.heightMultiplier,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: AppStyles.decorationBottomBorder(
                                Colors.white, 1),
                            child: MyButton(
                              title: "نسيت كلمة المرور؟   ",
                              bkgColor: Colors.black,
                              paddingValue: 0,
                              showShadow: false,
                              textAlign: TextAlign.left,
                              mainAlignment: MainAxisAlignment.start,
                              fontWight: FontWeight.bold,
                              titleColor: Colors.white,
                              titleSize: 10,
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ForgetPasswordScreen()));
                              },
                            ),
                          ),
                          // Container(
                          //   decoration: AppStyles.decorationBottomBorder(
                          //       Colors.white, 1),
                          //   child: MyButton(
                          //     title: "إنشاء حساب   ",
                          //     bkgColor: Colors.black,
                          //     paddingValue: 0,
                          //     showShadow: false,
                          //     textAlign: TextAlign.right,
                          //     mainAlignment: MainAxisAlignment.end,
                          //     fontWight: FontWeight.bold,
                          //     titleColor: Colors.white,
                          //     titleSize: 16,
                          //     onTap: () {
                          //       Navigator.of(context).push(MaterialPageRoute(
                          //           builder: (BuildContext context) =>
                          //               RegisterScreen()));
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 3 * SizeConfig.heightMultiplier,
                      ),
                      SocialButtons(),
                      Text("All rights reserved © Addrus E-Learning",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                      SizedBox(
                        height: 3 * SizeConfig.heightMultiplier,
                      ),
                    ],
                  )
                ],
              ),
            ),
            (isLoading)
                ? LoadingIndicator(
                    fullScreen: true,
                  )
                : Center()
          ],
        ),
      ),
    );
  }

  bool checkValidation() {
    var isValid = true;

    if (null == email || email.isEmpty) {
      setState(() {
        emailError = Message.EMPTY_FIELD;
      });
      isValid = false;
    } else {
      setState(() {
        emailError = "";
      });
    }

    if (null == password || password.isEmpty) {
      setState(() {
        passwordError = Message.EMPTY_FIELD;
      });
      isValid = false;
    } else {
      setState(() {
        passwordError = "";
      });
    }
    return isValid;
  }

  void _observeLogin(Result<LoginResponse> result) {
    print("Result Login:: ${result.getSuccessData()}");

    if (result is SuccessResult) {
      if (null != result.getSuccessData().user ||
          null != result.getSuccessData().access_token) {
        print("Token length: ${result.getSuccessData().access_token.length}");
        sessionManager.setUser(result.getSuccessData());
        sessionManager.setValue(UserConstants.LOGIN_EMAIL, email);
        sessionManager.setValue(UserConstants.LOGIN_PASSWORD, password);

        Timer(Duration(seconds: 1), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => WelcomeScreen()));
        });
      } else if (null != result.getSuccessData().message) {
        components.displayDialog(
            context, Message.ERROR_HAPPENED, result.getSuccessData().message);
      }
    } else if (result is ErrorResult) {
      components.displayDialog(
          context, Message.ERROR_HAPPENED, result.getErrorMessage());
    }

    setState(() {
      isLoading = false;
    });
  }
}
