import 'dart:async';
import 'dart:io';

import 'package:adrus/base/result.dart';
import 'package:adrus/data/models/responses/login_response.dart';
import 'package:adrus/data/models/responses/status_response.dart';
import 'package:adrus/di/injection_container.dart';
import 'package:adrus/ui/bloc/bloc_edit_profile.dart';
import 'package:adrus/ui/bloc/bloc_login.dart';
import 'package:adrus/ui/bloc/bloc_register.dart';
import 'package:adrus/ui/elements/image_picker.dart';
import 'package:adrus/utils/helpers/app_assets.dart';
import 'package:adrus/utils/helpers/app_colors.dart';
import 'package:adrus/utils/helpers/app_constants.dart';
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
import 'package:adrus/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:adrus/main.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScreenState();
  }
}

class ScreenState extends State<EditProfileScreen> {
  SessionManager sessionManager = sl<SessionManager>();
  final Components components = sl<Components>();
  final EditProfileBloc _editProfileBloc = sl<EditProfileBloc>();

  String name, email, password;
  String nameError, emailError, passwordError;
  bool isLoading = false;
  File imageFile;
  TextEditingController nameController, emailController, passwordController;

  @override
  void initState() {
    _editProfileBloc.mainStream.listen(_observeRegister);
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    setState(() {
      nameController.text = sessionManager.getUser().name;
      emailController.text = sessionManager.getUser().email;
      passwordController.text =
          sessionManager.getValue(UserConstants.LOGIN_PASSWORD);

      name = sessionManager.getUser().name;
      email = sessionManager.getUser().email;
      password = sessionManager.getValue(UserConstants.LOGIN_PASSWORD);
    });
  }

  @override
  void dispose() {
    // _editProfileBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: components.myAppBar("?????????? ???????????? ????????????", true),
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
                          "??????????????",
                          textAlign: TextAlign.right,
                          style: AppTextStyles.textStyle(
                              20, Colors.white, FontWeight.w900),
                        ),
                      ),
                      Positioned(
                        top: 2 * SizeConfig.heightMultiplier,
                        left: 3 * SizeConfig.heightMultiplier,
                        bottom: 0 * SizeConfig.heightMultiplier,
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
                              hint: sessionManager.getUser().name,
                              hitColor: AppColors.BLUE_MED,
                              textColor: AppColors.BLUE_MED,
                              fillColor: Colors.white,
                              borderColor: AppColors.BLUE_MED,
                              defaultBorderColor: AppColors.BLUE_MED,
                              linearBottomBorder: true,
                              borderRadius: 0,
                              elevation: 0,
                              controller: nameController,
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
                      // SizedBox(
                      //   height: 5 * SizeConfig.heightMultiplier,
                      // ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: MyTextField(
                      //         hint: sessionManager.getUser().email,
                      //         hitColor: AppColors.BLUE_MED,
                      //         textColor: AppColors.BLUE_MED,
                      //         fillColor: Colors.white,
                      //         borderColor: AppColors.BLUE_MED,
                      //         defaultBorderColor: AppColors.BLUE_MED,
                      //         linearBottomBorder: true,
                      //         borderRadius: 0,
                      //         elevation: 0,
                      //         controller: emailController,
                      //         inputType: TextInputType.emailAddress,
                      //         onValueChanged: (value) {
                      //           setState(() {
                      //             email = value;
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 2 * SizeConfig.heightMultiplier,
                      //     ),
                      //     Image.asset(
                      //       AppAssets.IC_MAIL,
                      //       width: 3.2 * SizeConfig.heightMultiplier,
                      //       height: 3.2 * SizeConfig.heightMultiplier,
                      //       color: AppColors.BLUE_MED,
                      //     ),
                      //   ],
                      // ),
                      // ErrorLabel(msg: emailError),
                      SizedBox(
                        height: 5 * SizeConfig.heightMultiplier,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: MyTextField(
                              hint: sessionManager
                                  .getValue(UserConstants.LOGIN_PASSWORD),
                              hitColor: AppColors.BLUE_MED,
                              textColor: AppColors.BLUE_MED,
                              fillColor: Colors.white,
                              borderColor: AppColors.BLUE_MED,
                              defaultBorderColor: AppColors.BLUE_MED,
                              linearBottomBorder: true,
                              borderRadius: 0,
                              elevation: 0,
                              controller: passwordController,
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
                        title: "??????",
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
                                _editProfileBloc.editProfile(
                                    name,
                                    // email,
                                    password,
                                    imageFile);
                              });
                            }
                          } else {
                            components.displayToast(context,
                                "?????????? ?????? ???????????????? ???? ?????????????? ?????????????? ...");
                          }
                        },
                      ),
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

    // if (null == email || email.isEmpty) {
    //   setState(() {
    //     emailError = Message.EMPTY_FIELD;
    //   });
    //   isValid = false;
    // }
    // else if (!RegExp(AppConstants.EMAIL_REGEX).hasMatch(email)) {
    //   setState(() {
    //     emailError = "???????? ???????????? ???????????????????? ?????????? ?????????? ?????? example@mail.com";
    //   });
    //   isValid = false;
    // }
    // else {
    //   setState(() {
    //     emailError = "";
    //   });
    // }

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
        var token = sessionManager.getValue(UserConstants.ACCESS_TOKEN);
        sessionManager.setUser(result.getSuccessData());
        sessionManager.setValue(UserConstants.ACCESS_TOKEN, token);
        sessionManager.setValue(UserConstants.LOGIN_PASSWORD, password);
        Timer(Duration(seconds: 1), () {
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
        if (result.getErrorMessage().contains("101")) {
          components.displayDialog(context, "", "offline");
        } else {
          components.displayDialog(
              context, Message.ERROR_HAPPENED, result.getErrorMessage());
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }
}
