import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/models/request/login/LoginRequestModel.dart';
import 'package:flutter_base/models/response/login_response/LoginResponse.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/route/routes.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_base/utils/strings.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/views/login/login_screen.dart';
import 'package:flutter_base/views/signup/signup_screen.dart';
import 'package:flutter_base/widgets/dialog_widget/dialog_widget.dart';
import 'package:flutter_base/widgets/loading_widget.dart';
import 'package:flutter_base/widgets/poppins_text_widget.dart';
import 'package:flutter_base/widgets/raleway_text_widget.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upgrader/upgrader.dart';
import '../../models/response/server_response.dart';
import '../../providers/api_forgot_password_notifier.dart';
import '../../utils/api_state_model.dart';
import '../../utils/image_assets.dart';
import '../../widgets/button_widget/success_dialog.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/text_field_widget/custom_text_field_splash.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // :: TODO sync data when widgets tree loaded
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      clearFields();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // :: TODO listen api response

    ref.listen<ApiStatesModel>(apiForgotPasswordNotifierProvider,
            (previous, apiStatesModel) {
          switch (apiStatesModel.states) {
            case States.DATA:
              if (apiStatesModel.data is ServerResponse) {
                final response = apiStatesModel.data as ServerResponse;

                final isSuccess = response.statusCode == 200;

                if (isSuccess) {
                  Fluttertoast.showToast(
                    msg: response.message ?? "enter valid email",
                    backgroundColor: ColorUtils.lightGreenColor,
                    textColor: ColorUtils.whiteColor,
                  );
                } else {
                  final errorMessage = (response.error != null &&
                      response.error.toString().isNotEmpty)
                      ? response.error.toString()
                      : response.message ?? "Something went wrong";

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: ColorUtils.redColor,
                    ),
                  );
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
        clearFields();
        Navigator.pop(context);
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
                    Image.asset(
                      plavsImage,
                      height: 220.h,
                      width: 300.w,
                      // fit: BoxFit.contain,
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
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
                            //TODO::  reset password text heading
                            Center(
                              child: RalewayTextWidget(
                                fontsize: 30.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.blackColor,
                                text: resetPasswordText,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            //TODO::  email heading
                            Center(
                              child: RalewayTextWidget(
                                fontsize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorUtils.mediumGrayColor,
                                text: detailResetPasswordText,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 30.h),
                            //TODO:: password heading text
                            RalewayTextWidget(
                              fontsize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorUtils.mediumGrayColor,
                              text: officialEmail,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 10.h),
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
                            SizedBox(height: 50.h),
                            //TODO::  elevated button of forgot password
                            SizedBox(
                              width: double.infinity,
                              child: CustomElevatedButton(
                                buttonText: sendResendLinkText,
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    _forgotPassword();
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
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  //TODO::  text of already account
                                  RalewayTextWidget(
                                    fontsize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ColorUtils.mediumGrayColor,
                                    text: rememberPassword,
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
                                        text: signInText,
                                        textAlign: TextAlign.center,
                                      ),
                                      onTap: () async{
                                        clearFields();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                            const LoginScreen(),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  //TODO::  api of login user
  void _forgotPassword() async {
    if (await Utils.isInternetAvailable()) {
      String email = _emailController.text;
      ref.read(emailLoginProvider.notifier).state = email;
      LoginRequestModel requestModel =
      LoginRequestModel(email: email,);
      ref.read(apiForgotPasswordNotifierProvider.notifier).apiForgotPassword(requestModel);
    } else {
      Utils.showToast(networkErrorMessage);
    }
  }
  clearFields(){
    _emailController.clear();
    ref.invalidate(emailLoginProvider);
    ref.refresh(emailLoginProvider);
  }
}
