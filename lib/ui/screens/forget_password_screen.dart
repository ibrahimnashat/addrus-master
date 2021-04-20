import 'dart:async';
import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/responses/login_response.dart';
import 'package:adrus/data/models/responses/status_response.dart';
import 'package:adrus/di/injection_container.dart';
import 'package:adrus/ui/bloc/bloc_forget_password.dart';
import 'package:adrus/ui/elements/login_header.dart';
import 'package:adrus/utils/helpers/app_assets.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/message.dart';
import 'package:adrus/utils/session_manager.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:adrus/widgets/components.dart';
import 'package:adrus/widgets/error_label.dart';
import 'package:adrus/widgets/loading_indicator.dart';
import 'package:adrus/widgets/my_button.dart';
import 'package:adrus/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:adrus/main.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScreenState();
  }
}

class ScreenState extends State<ForgetPasswordScreen> {
  SessionManager sessionManager = sl<SessionManager>();
  final Components components = sl<Components>();
  final ForgetPasswordBloc _forgetPasswordBloc = sl<ForgetPasswordBloc>();

  String email;
  String emailError;
  bool isLoading = false;
  BuildContext scaffoldCont;

  @override
  void initState() {
    _forgetPasswordBloc.mainStream.listen(_observeLogin);
    super.initState();
  }

  @override
  void dispose() {
    // _forgetPasswordBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (scaffoldContext) {
          scaffoldCont = scaffoldContext;
          return Stack(
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
                        SizedBox(
                          height: 5 * SizeConfig.heightMultiplier,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: MyTextField(
                                hint: "اسم المستخدم",
                                hitColor: AppColors.BLUE_MED,
                                textColor: AppColors.BLUE_MED,
                                fillColor: Colors.black,
                                borderColor: AppColors.BLUE_MED,
                                defaultBorderColor: AppColors.BLUE_MED,
                                linearBottomBorder: true,
                                borderRadius: 0,
                                elevation: 0,
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
                          height: 10 * SizeConfig.heightMultiplier,
                        ),
                        MyButton(
                          title: "نسيت كلمة المرور",
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
                                  _forgetPasswordBloc
                                      .handleForgetPassword(email);
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: AppStyles.decorationBottomBorder(
                                  Colors.white, 1),
                              child: MyButton(
                                title: "سجل دخول الان   ",
                                bkgColor: Colors.black,
                                paddingValue: 0,
                                showShadow: false,
                                textAlign: TextAlign.left,
                                mainAlignment: MainAxisAlignment.start,
                                fontWight: FontWeight.bold,
                                titleColor: Colors.white,
                                titleSize: 16,
                                onTap: () {
                                  Navigator.of(context).pop();
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
          );
        },
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
    return isValid;
  }

  void _observeLogin(Result<LoginResponse> result) {
    print("Result Login:: ${result.getSuccessData()}");
    if (result is SuccessResult) {
      if (null != result.getSuccessData().message) {
        // components.displayToast(context, result.getSuccessData().message) ;
        components.displaySnakBar(
            scaffoldCont, result.getSuccessData().message);
        Timer(Duration(seconds: 5), () {
          Navigator.of(context).pop();
        });
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
