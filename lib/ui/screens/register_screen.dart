import 'dart:async';
import 'dart:io';

import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/responses/login_response.dart';
import 'package:adrus/data/models/responses/status_response.dart';
import 'package:adrus/di/injection_container.dart';
import 'package:adrus/ui/bloc/bloc_login.dart';
import 'package:adrus/ui/bloc/bloc_register.dart';
import 'package:adrus/ui/elements/image_picker.dart';
import 'package:adrus/utils/helpers/app_assets.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_constants.dart';
import 'package:adrus/utils/helpers/app_styles.dart';
import 'package:adrus/utils/helpers/message.dart';
import 'package:adrus/utils/helpers/text_styles.dart';
import 'package:adrus/utils/session_manager.dart';
import 'package:adrus/utils/size_config.dart';
import 'package:adrus/widgets/components.dart';
import 'package:adrus/widgets/error_label.dart';
import 'package:adrus/widgets/loading_indicator.dart';
import 'package:adrus/widgets/my_button.dart';
import 'package:adrus/widgets/my_text_field.dart';
import 'package:adrus/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:adrus/main.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScreenState();
  }
}

class ScreenState extends State<RegisterScreen> {
  SessionManager sessionManager = sl<SessionManager>();
  final Components components = sl<Components>();
  final RegisterBloc _registerBloc = sl<RegisterBloc>();

  String name, email, password;
  String nameError, emailError, passwordError, clinicError;
  bool isLoading = false;
  File imageFile;

  @override
  void initState() {
    _registerBloc.mainStream.listen(_observeRegister);
    super.initState();
  }

  @override
  void dispose() {
    // _registerBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: components.myAppBar("إنشاء حساب"),
      body: Builder(
        builder: (scaffoldContext) => Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: AppStyles.paddingSymmetric(4, 4),
                        margin: EdgeInsets.only(
                            bottom: 7 * SizeConfig.heightMultiplier),
                        color: AppColors.YELLOW_DARK,
                        child: Text(
                          "بياناتي",
                          textAlign: TextAlign.right,
                          style: AppTextStyles.textStyle(
                              20, Colors.white, FontWeight.w900),
                        ),
                      ),
                      Positioned(
                        top: 2 * SizeConfig.heightMultiplier,
                        left: 3 * SizeConfig.heightMultiplier,
                        bottom: 0 * SizeConfig.heightMultiplier,
                        width: 18 * SizeConfig.heightMultiplier,
                        height: 18 * SizeConfig.heightMultiplier,
                        child: MyImagePicker(
                          size: 18,
                          onImagePicked: (String value) {
                            // setState(() {
                            print("$value");
                            imageFile = File(value);
                            // });
                          },
                        ),
                      ),
                    ],
                  ),
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
                              hint: "الاسم",
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
                                  name = value;
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
                            color: AppColors.BLUE_MED,
                          ),
                        ],
                      ),
                      ErrorLabel(msg: nameError),
                      SizedBox(
                        height: 5 * SizeConfig.heightMultiplier,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MyTextField(
                              hint: "البريد الإلكترونى",
                              hitColor: AppColors.BLUE_MED,
                              textColor: AppColors.BLUE_MED,
                              fillColor: Colors.black,
                              borderColor: AppColors.BLUE_MED,
                              defaultBorderColor: AppColors.BLUE_MED,
                              linearBottomBorder: true,
                              borderRadius: 0,
                              elevation: 0,
                              inputType: TextInputType.emailAddress,
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
                            AppAssets.IC_MAIL,
                            width: 3.2 * SizeConfig.heightMultiplier,
                            height: 3.2 * SizeConfig.heightMultiplier,
                            color: AppColors.BLUE_MED,
                          ),
                        ],
                      ),
                      ErrorLabel(msg: emailError),
                      SizedBox(
                        height: 5 * SizeConfig.heightMultiplier,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MyTextField(
                              hint: "كلمة المرور",
                              hitColor: AppColors.BLUE_MED,
                              textColor: AppColors.BLUE_MED,
                              fillColor: Colors.black,
                              borderColor: AppColors.BLUE_MED,
                              defaultBorderColor: AppColors.BLUE_MED,
                              linearBottomBorder: true,
                              borderRadius: 0,
                              elevation: 0,
                              secureText: true,
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
                            color: AppColors.BLUE_MED,
                          ),
                        ],
                      ),
                      ErrorLabel(msg: passwordError),
                      SizedBox(
                        height: 10 * SizeConfig.heightMultiplier,
                      ),
                      MyButton(
                        title: "التالي",
                        bkgColor: AppColors.BLUE_DARK,
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
                                _registerBloc.handleRegister(
                                    name, email, password, imageFile);
                              });
                            }
                          } else {
                            components.displayToast(context,
                                "انتظر حتى الانتهاء من العملية الحالية ...");
                          }
                        },
                      ),
                      SizedBox(
                        height: 2 * SizeConfig.heightMultiplier,
                      ),
                      Text(
                          "All rights reserved © Addrus E-Learning\nPowered by Shetewy-Tech Türkiye",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
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

    if (null == name || name.isEmpty) {
      setState(() {
        nameError = Message.EMPTY_FIELD;
      });
      isValid = false;
    } else {
      setState(() {
        nameError = "";
      });
    }

    if (null == email || email.isEmpty) {
      setState(() {
        emailError = Message.EMPTY_FIELD;
      });
      isValid = false;
    }
    // else if (!RegExp(AppConstants.EMAIL_REGEX).hasMatch(email)) {
    //   setState(() {
    //     emailError = "ادخل البريد الإلكترونى بصيغة صحيحة مثل example@mail.com";
    //   });
    //   isValid = false;
    // }
    else {
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

  void _observeRegister(Result<LoginResponse> result) {
    if (result is SuccessResult) {
      print("success");
      if (null != result.getSuccessData().message) {
        components.displayToast(context, result.getSuccessData().message);
        Timer(Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
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
