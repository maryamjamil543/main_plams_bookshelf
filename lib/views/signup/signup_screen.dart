import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/models/response/server_response.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/providers/api_register_notifier.dart';
import 'package:flutter_base/route/routes.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_base/utils/strings.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/dialog_widget/dialog_widget.dart';
import 'package:flutter_base/widgets/loading_widget.dart';
import 'package:flutter_base/widgets/raleway_text_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/request/register/RegisterRequestModel.dart';
import '../../models/response/login_response/Country.dart';
import '../../utils/api_state_model.dart';
import '../../utils/image_assets.dart';
import '../../widgets/custom_drop_down_search.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/text_field_widget/custom_text_field_splash.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends ConsumerState<SignUpScreen> {
  final fullNameController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final officalEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confrimPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
        WidgetsBinding.instance.addPostFrameCallback((callBack) async {
      //TODO :: get data through database
          clearFields();
      if (await Utils.isInternetAvailable()) {
        getDropDownsData();
      }
    });
  }
  //TODO:: countries or cities dropdown list
  Future<void> getDropDownsData() async {
    await ref
        .read(apiRegisterNotifierProvider.notifier)
        .getAllCountries();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // :: TODO listen api response
    ref.listen<ApiStatesModel>(apiRegisterNotifierProvider,
        (previous, apiStatesModel) {
      switch (apiStatesModel.states) {
        case States.DATA:
          if (apiStatesModel.data is ServerResponse) {
            final response = apiStatesModel.data as ServerResponse;
            Fluttertoast.showToast(msg: apiStatesModel.message ?? "Success");
            clearFields();
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.LOGIN, (route) => false);
          }
          break;

        case States.ERROR:
          String errorMessage = "Something went wrong";

          if (apiStatesModel.data is ServerResponse) {
            final errorResponse = apiStatesModel.data as ServerResponse;

            if (errorResponse.error != null &&
                errorResponse.error!.isNotEmpty) {
              errorMessage = errorResponse.error!.join("\n");
            } else {
              errorMessage = apiStatesModel.message ?? "Error occurred";
            }
          } else {
            errorMessage = apiStatesModel.message ?? "Connection Error";
          }

          Fluttertoast.showToast(
            msg: errorMessage,
            toastLength: Toast.LENGTH_LONG,
          );
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
        LoadingWidget(),
      ],
    );
  }

  Widget _mainLayout() {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorUtils.whiteColor,
        appBar: AppBar(
          backgroundColor: ColorUtils.whiteColor,
          surfaceTintColor: ColorUtils.whiteColor,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(
            color: ColorUtils.blackColor
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 9.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //TODO:: image icon of app
                Image.asset(
                  plavsImage,
                  height: 220.h,
                  width: 300.w,
                  // fit: BoxFit.contain,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
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
                            //TODO:: signup text
                            Center(
                              child: RalewayTextWidget(
                                fontsize: 30.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.blackColor,
                                text: signUpText,
                                textAlign: TextAlign.start,
                              ),
                            ),
                            SizedBox(height: 5.h),
                            //TODO:: get started heading text
                            Center(
                              child: RalewayTextWidget(
                                fontsize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.lightBlackTextColor,
                                text: createYourAccount,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            //TODO:: full name heading
                            RalewayTextWidget(
                              fontsize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorUtils.mediumGrayColor,
                              text: fullName,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 7.h),
                            //TODO:: full name TextField
                            CustomTextFieldSplash(
                              controller: fullNameController,
                              labelText: enterName,
                              hintColor: ColorUtils.lightBlackTextColor,
                              keyboardType: TextInputType.text,
                              // icon: Icon(Icons.email_outlined),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return enterName;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),
                            //TODO:: email heading
                            RalewayTextWidget(
                              fontsize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorUtils.mediumGrayColor,
                              text: officialEmail,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 7.h),
                            //TODO:: official email
                            CustomTextFieldSplash(
                              controller: officalEmailController,
                              labelText: enterEmail,
                              textInputAction: TextInputAction.done,
                              hintColor: ColorUtils.lightBlackTextColor,
                              keyboardType: TextInputType.emailAddress,
                              isPasswordField: false, // FIXED
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return emailValidationError;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 7.h),
                            //TODO:: country heading
                            RalewayTextWidget(
                              fontsize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorUtils.mediumGrayColor,
                              text: countryTypeText,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            //TODO::country dropdown
                            CustomDropdownSearch(
                              showSearchBox: true,
                              items: ref.watch(countryListProvider),
                              selectedItem: ref.watch(selectedCountryProvider),
                              onChanged: (country) {
                                ref
                                    .read(selectedCountryProvider.notifier)
                                    .state = country;
                                ref.read(cityListProvider.notifier).state =
                                    country?.cities ?? [];
                                ref.read(selectedCityProvider.notifier).state =
                                    null;
                              },
                              itemAsString: (country) =>
                                  country?.name ?? "--Select Country--",
                              onValidate: (value) {
                                if (value == null) {
                                  return selectCountry;
                                } else if (value.name == null ||
                                    value.name!
                                        .toLowerCase()
                                        .contains("please")) {
                                  return selectCountry;
                                } else {
                                  return null;
                                }
                              },
                            ),
                            //TODO:: city heading
                            RalewayTextWidget(
                              fontsize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorUtils.mediumGrayColor,
                              text: cityText,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            //TODO:: selected city bases on the selected country  dropdown
                            CustomDropdownSearch(
                              showSearchBox: true,
                              items: ref.watch(cityListProvider),
                              selectedItem: ref.watch(selectedCityProvider),
                              onChanged: (city) {
                                ref.read(selectedCityProvider.notifier).state =
                                    city;
                              },
                              itemAsString: (city) => city ?? "--Select City--",
                              onValidate: (value) {
                                if (value == null || value.isEmpty)
                                  return selectCity;
                                return null;
                              },
                            ),
                            //TODO:: password heading
                            RalewayTextWidget(
                              fontsize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorUtils.mediumGrayColor,
                              text: passwordString,
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(height: 7.h),
                            //TODO:: password text field
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
                                if (value.length < 8) {
                                  return validationErrorPasswordText;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.h),
                            //TODO:: confirm password heading
                            RalewayTextWidget(
                              fontsize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorUtils.mediumGrayColor,
                              text: confrimPassword,
                              textAlign: TextAlign.start,
                            ),
                            //TODO::confirm password text field
                            SizedBox(height: 16.h),
                            CustomTextFieldSplash(
                              controller: _confrimPasswordController,
                              labelText: confirmPasswordString,
                              textInputAction: TextInputAction.done,
                              hintColor: ColorUtils.lightBlackTextColor,
                              keyboardType: TextInputType.visiblePassword,
                              isPasswordField: true,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return confirmValidationError;
                                }
                                if (value != _passwordController.text) {
                                  return passwordDontMatch;
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 50.h),
                           //TODO :: Elevated button of sing up
                            SizedBox(
                              width: double.infinity,
                              child: CustomElevatedButton(
                                buttonText: signUpText,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// :: TODO login credentials
  void _login() async {
    if (await Utils.isInternetAvailable()) {
      String name = fullNameController.text;
      String country = countryController.text;
      String city = cityController.text;
      String officalEmail = officalEmailController.text;
      String password = _passwordController.text;
      String confirmPassword = _confrimPasswordController.text;
      ref.read(nameProvider.notifier).state = name;
      ref.read(emailProvider.notifier).state = officalEmail;
      ref.read(passwordRegisterProvider.notifier).state = password;
      ref.read(confrimPasswordRegisterProvider.notifier).state =
          confrimPassword;
      RegisterRequestModel requestModel = RegisterRequestModel(
        email: officalEmail,
        password: password,
        confirmPassword: confirmPassword,
        name: name,
        country: ref.read(selectedCountryProvider)?.name.toString() ?? '',
        city: ref.read(selectedCityProvider) ?? '',
      );
      ref.read(apiRegisterNotifierProvider.notifier).apiRegister(requestModel);
    } else {
      Utils.showToast(networkErrorMessage);
    }
  }
  //TODO :: clear fields function
  void clearFields(){
    ref.invalidate(selectedCityProvider);
    ref.invalidate(selectedCountryProvider);
  }
}
