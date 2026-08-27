import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/models/response/server_response.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_base/utils/image_assets.dart';
import 'package:flutter_base/utils/strings.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/dialog_widget/dialog_widget.dart';
import 'package:flutter_base/widgets/loading_widget.dart';
import 'package:flutter_base/widgets/raleway_text_widget.dart';
import 'package:flutter_base/widgets/text_field_widget/custom_text_field_splash.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../models/response/get_library_response/Library.dart';
import '../../models/response/login_response/PlatformPackage.dart';
import '../../models/response/subscription_plan/SubscriptionResponseModel.dart';
import '../../providers/api_subscription_detail_notifier.dart';
import '../../utils/api_state_model.dart';
import '../../utils/custom_functions.dart';
import '../../widgets/button_widget/success_dialog.dart';
import '../../widgets/custom_drop_down_search.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/poppins_text_widget.dart';

class SuscriptionDetailScreen extends ConsumerStatefulWidget {
  final Library? libraryJson;
  final PlatformPackage? preSelectedPackage;

  const SuscriptionDetailScreen(
      {super.key, this.libraryJson, this.preSelectedPackage});

  @override
  SuscriptionDetailScreenState createState() => SuscriptionDetailScreenState();
}

class SuscriptionDetailScreenState
    extends ConsumerState<SuscriptionDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final searchController = TextEditingController();
  final bookTitleController = TextEditingController();
  final authorsController = TextEditingController();
  final pagesController = TextEditingController();
  final descriptionController = TextEditingController();
  final bookEditionController = TextEditingController();
  final authorController = TextEditingController();
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  final publisherDateController = TextEditingController();
  final isbController = TextEditingController();
  final mobileNumberController = MaskedTextController(mask: "0000-0000000");
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  bool isChecked = false;


  @override
  void initState() {
    super.initState();
    // :: TODO sync data when widgets tree loaded
    WidgetsBinding.instance.addPostFrameCallback((_) async {

      clearFields();
      if (await Utils.isInternetAvailable()) {
        final libraryId = widget.libraryJson?.id;

        if (libraryId != null) {
          //TODO:: Call library subscription API
          await ref
              .read(apiSubscriptionDetailNotifierProvider.notifier)
              .getSubscriptionByLibrary(libraryId);
        } else {
          Utils.showToast(networkErrorMessage);
        }
        if (widget.preSelectedPackage != null) {
          ref.read(selectedTypeOfPlatForm.notifier).state =
              widget.preSelectedPackage!;
        }
      }
    });
  }
//TODO:: get dropdown data
  Future<void> getDropDownsData() async {
    await ref
        .read(apiSubscriptionDetailNotifierProvider.notifier)
        .getAllPaymentMethod();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // :: TODO listen api responses
    ref.listen<ApiStatesModel>(apiSubscriptionDetailNotifierProvider,
        (previous, apiStatesModel) {
      switch (apiStatesModel.states) {
        case States.DATA:
          if (apiStatesModel.data is ServerResponse &&
              apiStatesModel.data is! SubscriptionResponseModel) {
            final _response = apiStatesModel.data as ServerResponse;

            final status = _response.status?.toLowerCase() ?? "";
            final message = _response.message ?? "";

            if (status == "success") {
              ref.read(isFormSubmittedProvider.notifier).state = true;
              Future.microtask(() {
                if (!mounted) return;

                showDialog(
                  context: context,
                  builder: (context) => SuccessDialog(message: message),
                );
              });

            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message.isNotEmpty ? message : "Something went wrong"),
                ),
              );
            }
          } else if (apiStatesModel.data is SubscriptionResponseModel) {
            final response = apiStatesModel.data as SubscriptionResponseModel;

            final status = response.status?.toLowerCase() ?? "";

            final message = response.status ?? "No message from server";

            if (status == "success") {
              // Fluttertoast.showToast(
              //   msg: "Success",
              //   backgroundColor: ColorUtils.greenColor,
              //   textColor: Colors.white,
              // );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                ),
              );
            }
          }
          break;

        case States.ERROR:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(apiStatesModel.message ?? "Error occurred")),
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
        // :: TODO loading widget
        const LoadingWidget(),
      ],
    );
  }

  Widget _mainLayout() {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        clearFields();
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorUtils.whiteColor,
        key: _key,
        body: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
            // :: TODO background image
            child: Image.asset(
              dashboardBackgroundImage,
              height: 0.27.sh,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
              bottom: false,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 0.23.sh,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 24.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // :: TODO back arrow icon
                            Row(
                              children: [
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: SvgPicture.asset(
                                    backArrow,
                                    height: 35.h,
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                // :: TODO detail subscription detail
                                RalewayTextWidget(
                                  fontsize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.whiteColor,
                                  text: detailSubscripton,
                                ),
                                const Spacer(),
                              ],
                            ),
                            SizedBox(
                              height: 80.h,
                            ),
                            // :: TODO search text field
                            Visibility(
                              visible: false,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minHeight: 50.h,
                                        maxHeight: 50.h,
                                      ),
                                      child: CustomTextFieldSplash(
                                        controller: searchController,
                                        labelText: searchText,
                                        fontSize: 21.sp,
                                        hintColor:
                                            ColorUtils.lightBlackTextColor,
                                        keyboardType: TextInputType.text,
                                        isSearchField: true,
                                        prefixIconWidget: SvgPicture.asset(
                                          searchIcon,
                                          height: 32.h,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  InkWell(
                                    onTap: () {
                                      // Handle filter tap
                                    },
                                    child: SvgPicture.asset(
                                      filterIcon,
                                      height: 40.h,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.0.w, right: 30.w),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20.h,
                                ),
                                // :: TODO select platform select
                                Visibility(
                                  visible: () {
                                    final selected =
                                        ref.watch(selectedTypeOfPlatForm);
                                    return selected != null &&
                                        selected.name != null &&
                                        selected.name!.trim().isNotEmpty;
                                  }(),
                                  child: Builder(
                                    builder: (_) {
                                      final selected =
                                          ref.watch(selectedTypeOfPlatForm);
                                      if (selected == null)
                                        return const SizedBox();

                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                5,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              color: ColorUtils.blueColor,
                                              // blue background
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12.h),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  //TODO:: order summary text
                                                  RalewayTextWidget(
                                                    fontsize: 22.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: ColorUtils.whiteColor,
                                                    // text on blue
                                                    text: orderSummary,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // :: TODO plan text heading
                                                      RalewayTextWidget(
                                                        fontsize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: ColorUtils
                                                            .mediumGrayColor,
                                                        text: planText,
                                                      ),
                                                      // :: TODO name of plan text
                                                      RalewayTextWidget(
                                                        fontsize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: ColorUtils
                                                            .mediumGrayColor,
                                                        text: selected.name ??
                                                            "N/A",
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // :: TODO duration text
                                                      RalewayTextWidget(
                                                        fontsize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: ColorUtils
                                                            .mediumGrayColor,
                                                        text: durationText,
                                                      ),
                                                      // :: TODO duration days
                                                      RalewayTextWidget(
                                                        fontsize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: ColorUtils
                                                            .mediumGrayColor,
                                                        text: "${selected.durationDays ?? 0}",
                                                            // "${selected.durationValue ?? ""} ${selected.durationType ?? ""}",
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      // :: TODO total text heading
                                                      RalewayTextWidget(
                                                        fontsize: 17.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: ColorUtils
                                                            .mediumGrayColor,
                                                        text: totalText,
                                                      ),
                                                      // :: TODO price
                                                      RalewayTextWidget(
                                                        fontsize: 22.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: ColorUtils
                                                            .blueColor,
                                                        text: selected.price ??
                                                            "N/A",
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                // :: TODO payment method text
                                RalewayTextWidget(
                                  fontsize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.mediumGrayColor,
                                  text: paymentMethodText,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                // :: TODO list of payment method
                                CustomDropdownSearch(
                                  showSearchBox: false,
                                  items:
                                      ref.watch(typeOfPaymentListStateProvider),
                                  selectedItem:
                                      ref.watch(selectedTypeOfPaymentMethod),
                                  onChanged: (selectedItem) {
                                    ref
                                        .read(selectedTypeOfPaymentMethod
                                            .notifier)
                                        .state = selectedItem!;
                                  },
                                  itemAsString: (typeOfIndustry) {
                                    if (typeOfIndustry == null) {
                                      return "Not selected";
                                    } else {
                                      return typeOfIndustry.name ?? "Select";
                                    }
                                  },
                                  onValidate: (value) {
                                    // Check if value is null before trying to access its properties
                                    if (value == null) {
                                      return selectTypeOfIndustry;
                                    } else if (value.name == null ||
                                        value.name!
                                            .toLowerCase()
                                            .contains("please")) {
                                      return selectTypeOfIndustry;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Visibility(
                                  visible: () {
                                    final selected =
                                        ref.watch(selectedTypeOfPaymentMethod);
                                    return selected != null &&
                                        selected.name != null &&
                                        selected.name!.trim().isNotEmpty;
                                  }(),
                                  child: Builder(
                                    builder: (_) {
                                      final selected = ref
                                          .watch(selectedTypeOfPaymentMethod);
                                      if (selected == null)
                                        return  SizedBox();

                                      return Container(
                                        padding:  EdgeInsets.only(left: 12.w,right: 12.w,top: 12.h,bottom: 12.h),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // :: TODO transfer detail text heading
                                            RalewayTextWidget(
                                              fontsize: 18.sp,
                                              fontWeight: FontWeight.w700,
                                              color: ColorUtils.blueColor,
                                              text: transferDetails,
                                            ),
                                            SizedBox(height: 8.h),
                                            // :: TODO detail of account
                                            RalewayTextWidget(
                                              fontsize: 15.sp,
                                              fontWeight: FontWeight.w700,
                                              color: ColorUtils.mediumGrayColor,
                                              text: selected.details ?? "N/A",
                                            ),
                                             SizedBox(height: 8.h),
                                            // :: TODO instruction
                                            RalewayTextWidget(
                                              fontsize: 15.sp,
                                              fontWeight: FontWeight.w700,
                                              color: ColorUtils.mediumGrayColor,
                                              text: selected.instructions ??
                                                  "N/A",
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                // :: TODO select plan text heading
                                RalewayTextWidget(
                                  fontsize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.mediumGrayColor,
                                  text: selectPlanText,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                // :: TODO dropdown of plat from package
                                CustomDropdownSearch(
                                  showSearchBox: false,
                                  items: ref.watch(
                                      typeOfPlatformPackageListStateProvider),
                                  selectedItem:
                                      ref.watch(selectedTypeOfPlatForm),
                                  onChanged: (selectedItem) {
                                    ref
                                        .read(selectedTypeOfPlatForm.notifier)
                                        .state = selectedItem!;
                                  },
                                  itemAsString: (typeOfIndustry) {
                                    if (typeOfIndustry == null) {
                                      return "Not selected";
                                    } else {
                                      return typeOfIndustry.name ??
                                          "--select--";
                                    }
                                  },
                                  onValidate: (value) {
                                    if (value == null) {
                                      return selectTypeOfSelectedPlan;
                                    } else if (value.name == null ||
                                        value.name!
                                            .toLowerCase()
                                            .contains("please")) {
                                      return selectTypeOfSelectedPlan;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),

                                SizedBox(
                                  height: 30.h,
                                ),
                                // :: TODO proof of transaction
                                PoppinsTextWidget(
                                  fontsize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ColorUtils.lightBlackColor,
                                  text: pictureOfTranstion,
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(height: 7.h),
                                GestureDetector(
                                  onTap: () {
                                    pickMedia(
                                        context: context,
                                        ref: ref,
                                        type: 'transaction_screenshot');
                                  },
                                  child: Center(
                                    child: Stack(
                                      children: [
                                        //TODO :: Circular Avatar
                                        (ref.watch(pictureOfTransctionStateProvider) ==
                                                '')
                                            ? Container(
                                                width: 120.w,
                                                height: 120.h,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r),
                                                    image:
                                                        const DecorationImage(
                                                            image: AssetImage(
                                                                addImageIcon))),
                                              )
                                            : (ref
                                                    .watch(
                                                        pictureOfTransctionStateProvider)
                                                    .contains('https'))
                                                ? CircleAvatar(
                                                    radius: 50,
                                                    child: ClipOval(
                                                      child: CachedNetworkImage(
                                                        height: double.infinity,
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                        // Ensures the image covers the entire avatar
                                                        imageUrl: ref.watch(
                                                            pictureOfTransctionStateProvider),
                                                        placeholder:
                                                            (context, url) =>
                                                                const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    width: 120.w,
                                                    height: 120.h,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                        image: DecorationImage(
                                                            image: FileImage(
                                                                File(ref.watch(
                                                                    pictureOfTransctionStateProvider))))),
                                                  )
                                        // Edit Icon positioned at the bottom right
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                // :: TODO elevated button of submit api
                                SizedBox(
                                  width: double.infinity,
                                  child: CustomElevatedButton(
                                    buttonText: submitText,
                                    // "Add Book"
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        if (validateForm()) {
                                          _submitForm();
                                        }
                                      } //
                                    },
                                    backgroundColor: ColorUtils.lightGreenColor,
                                    borderColor: ColorUtils.lightGreenColor,
                                    textColor: ColorUtils.whiteColor,
                                    height: 80.h,
                                    fontSize: 28.sp,
                                  ),
                                ),

                                SizedBox(
                                  height: 30.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ])),
        ]),
      ),
    );
  }
  // :: TODO validate
  bool validateForm() {
    String pictureOfChimney = ref.read(pictureOfTransctionStateProvider);

    if (pictureOfChimney == "") {
      Utils.showToast(selectPictureOfTransaction);
      return false;
    }

    return true;
  }

  // :: TODO Save Form to Server
  void _submitForm() async {
    if (await Utils.isInternetAvailable()) {
      if (widget.libraryJson?.id != null) {
        await ref
            .read(apiSubscriptionDetailNotifierProvider.notifier)
            .apiSubmitSubscriptionForm(widget.libraryJson!.id);
      } else {
        Utils.showToast("Library not selected");
        return; // Stop submission
      }
    } else {}
  }
  // :: TODO clear field
clearFields(){
    ref.invalidate(pictureOfTransctionStateProvider);
    ref.invalidate(selectedTypeOfPaymentMethod);
    ref.invalidate(selectedTypeOfPlatForm);
    ref.invalidate(typeOfPlatformPackageListStateProvider);
    ref.invalidate(typeOfPaymentListStateProvider);
    ref.invalidate(pictureOfTransctionStateProvider);
    ref.invalidate(selectedTypeOfPlatForm);
    ref.invalidate(selectedTypeOfPaymentMethod);
    ref.invalidate(apiSubscriptionDetailNotifierProvider);
}
}
