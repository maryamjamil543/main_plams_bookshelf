import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/models/request/login/LoginRequestModel.dart';
import 'package:flutter_base/models/response/login_response/LoginResponse.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/providers/api_auth_notifier.dart';
import 'package:flutter_base/route/routes.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_base/utils/strings.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/views/signup/signup_screen.dart';
import 'package:flutter_base/widgets/custom_logo_widget.dart';
import 'package:flutter_base/widgets/dialog_widget/dialog_widget.dart';
import 'package:flutter_base/widgets/loading_widget.dart';
import 'package:flutter_base/widgets/poppins_text_widget.dart';
import 'package:flutter_base/widgets/raleway_text_widget.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upgrader/upgrader.dart';
import '../../utils/api_state_model.dart';
import '../../utils/image_assets.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/text_field_widget/custom_text_field_splash.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // :: TODO listen api response

    ref.listen<ApiStatesModel>(apiAuthNotifierProvider,
        (previous, apiStatesModel) {
      switch (apiStatesModel.states) {
        case States.DATA:
          if (apiStatesModel.data is LoginResponse) {
            final response = apiStatesModel.data as LoginResponse;

            final message = apiStatesModel.message ?? "Login successful";

            // Dashboard navigate if response.data exists
            if (response.data != null) {
              Navigator.pushNamedAndRemoveUntil(
                  context, Routes.DASHBOARD, (route) => false);

              Fluttertoast.showToast(
                  msg: message, toastLength: Toast.LENGTH_SHORT);
            } else {
              Fluttertoast.showToast(
                  msg: message, toastLength: Toast.LENGTH_SHORT);
            }
          }
          break;

        case States.ERROR:
          Fluttertoast.showToast(
              msg: apiStatesModel.message ?? "Something went wrong",
              toastLength: Toast.LENGTH_SHORT);
          break;

        case States.SESSIONEXPIRED:
          DialogBuilder.showLogoutDialog(
            title: sessionExpiredText,
            content: sessionExpiredContent,
            isCancelable: false,
            buttonText: okButtonText,
            context: context,
            callback: () {},
          );
          break;

        default:
          break;
      }
    });

    return Stack(
      children: [
        _mainLayout(),
        // :: TODO loading Widget
        const LoadingWidget(),
      ],
    );
  }

  Widget _mainLayout() {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: UpgradeAlert(
        child: Scaffold(
          backgroundColor: ColorUtils.whiteColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 9.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100.h,
                    ),
                    //TODO:: logo icon
                    //TODO :: build logo icon widget
                    const CustomLogoWidget(),
                    //TODO :: build login  Widget
                    buildLoginWidget(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  //TODO:: Login Widget
  Widget buildLoginWidget(){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 10.h,
            left: 22.w,
            right: 22.w,
            bottom: 16.h,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //TODO::  login text heading
                Center(
                  child: RalewayTextWidget(
                    fontsize: 30.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorUtils.blackColor,
                    text: logInText,
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(height: 16.h),
                //TODO::  email heading
                RalewayTextWidget(
                  fontsize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorUtils.mediumGrayColor,
                  text: emailPhoneText,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 7.h),
                //TODO::  email text field
                CustomTextFieldSplash(
                  controller: _emailController,
                  labelText: hintEmailPhoneText,
                  hintColor: ColorUtils.lightBlackTextColor,
                  keyboardType: TextInputType.text,
                  // icon: Icon(Icons.email_outlined),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return emailTextLabelError;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                //TODO:: password heading text
                RalewayTextWidget(
                  fontsize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorUtils.mediumGrayColor,
                  text: passwordString,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 7.h),
                //TODO::  password text field
                CustomTextFieldSplash(
                  controller: _passwordController,
                  labelText: passwordHint,
                  textInputAction: TextInputAction.done,
                  hintColor: ColorUtils.lightBlackTextColor,
                  keyboardType: TextInputType.visiblePassword,
                  isPasswordField: true,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return passwordValidationError;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 7.h,),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.FORGOT_SCREEN);
                      // or Get.to(ForgotPasswordScreen());
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: RalewayTextWidget(
                      fontsize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorUtils.redColor,
                      text: forgotPasswordString,
                      textAlign: TextAlign.start,
                    ),
                  ),

                ),
                SizedBox(height: 50.h),
                //TODO::  elevated button of login
                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    buttonText: loginText,
                    onPressed: () {
                      if (_formKey.currentState?.validate() ??
                          false) {
                        _login();
                      }
                    },
                    backgroundColor: ColorUtils.lightGreenColor,
                    borderColor: ColorUtils.lightGreenColor,
                    textColor: ColorUtils.whiteColor,
                    height: 80.h,
                    fontSize: 28.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                //TODO::  elevated button of guest user
                Visibility(
                  visible: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      buttonText: guestContinueText,
                      onPressed: () {
                        // if (_formKey.currentState?.validate() ?? false) {
                        // }
                      },
                      fontSize: 31.sp,
                      backgroundColor:
                      ColorUtils.backgroundLightColor,
                      textColor: ColorUtils.mediumGrayColor,
                      borderColor: ColorUtils.backgroundLight,
                      // height: 110.h,// Text color
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //TODO::  text of already account
                      RalewayTextWidget(
                        fontsize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorUtils.mediumGrayColor,
                        text: donotHaveAccount,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      //TODO::  sing up text
                      InkWell(
                          child: RalewayTextWidget(
                            fontsize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorUtils.blackColor,
                            text: signUpText,
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const SignUpScreen(),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),],
    );

  }
  //TODO::  api of login user
  void _login() async {
    if (await Utils.isInternetAvailable()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      ref.read(emailLoginProvider.notifier).state = email;
      ref.read(passwordLoginProvider.notifier).state = password;
      LoginRequestModel requestModel =
          LoginRequestModel(email: email, password: password);
      ref.read(apiAuthNotifierProvider.notifier).apiLogin(requestModel);
    } else {
      Utils.showToast(networkErrorMessage);
    }
  }
}
