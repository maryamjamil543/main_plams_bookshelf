import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_base/utils/image_assets.dart';
import 'package:flutter_base/utils/strings.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/custom_drop_down_search.dart';
import 'package:flutter_base/widgets/custom_elevated_button.dart';
import 'package:flutter_base/widgets/dialog_widget/dialog_widget.dart';
import 'package:flutter_base/widgets/loading_widget.dart';
import 'package:flutter_base/widgets/raleway_text_widget.dart';
import 'package:flutter_base/widgets/text_field_widget/custom_text_field_splash.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../models/response/event/Events.dart';
import '../../models/response/server_response.dart';
import '../../models/response/subscription_plan/SubscriptionResponseModel.dart';
import '../../providers/api_dashboard_notifier.dart';
import '../../providers/api_events_register_notifier.dart';
import '../../utils/api_state_model.dart';
import '../../utils/custom_functions.dart';
import '../../widgets/button_widget/success_dialog.dart';
import '../../widgets/poppins_text_widget.dart';

class EventRegisterScreen extends ConsumerStatefulWidget {
  final Event? event;

  const EventRegisterScreen({super.key, this.event});

  @override
  EventScreenState createState() => EventScreenState();
}

class EventScreenState extends ConsumerState<EventRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();
  final notesController = TextEditingController();
  final _mobileController = MaskedTextController(mask: "0000-0000000");


  @override
  void initState() {
    super.initState();
    // :: TODO sync data when widgets tree loaded
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      clearField();
      final userData = await Utils.getUserData();
      if (userData != null) {
        ref
            .read(userProvider.notifier)
            .state = userData.user;
        if (showPaymentSection) {
      if (await Utils.isInternetAvailable()) {
          final libraryId = widget.event?.libraryId;
          if (libraryId != null) {
            final id = int.tryParse(libraryId.toString());

            if (id != null) {
              await ref
                  .read(apiEventRegisterNotifierProvider.notifier)
                  .getSubscriptionByLibrary(id);
            }
          }
        } else {
          Utils.showToast(networkErrorMessage);
        }
      }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // :: TODO listen api responses
    ref.listen<ApiStatesModel>(apiEventRegisterNotifierProvider,
            (previous, apiStatesModel) {
          switch (apiStatesModel.states) {
            case States.ERROR:
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(apiStatesModel.message),
              ));
              break;
            case States.DATA:
              if (apiStatesModel.data
              is SubscriptionResponseModel) {

                final response =
                apiStatesModel.data as SubscriptionResponseModel;

                final status =
                    response.status?.toLowerCase() ?? "";

                final message =
                    response.status ?? "No message from server";

                if (status == "success") {

                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     backgroundColor: ColorUtils.greenColor,
                  //     content: Text(status),
                  //   ),
                  // );

                } else {

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                    ),
                  );
                }
              }
              else if (apiStatesModel.data is ServerResponse) {

                final response = apiStatesModel.data as ServerResponse;

                final isSuccess = response.statusCode == 201;

                if (isSuccess) {

                  ref.read(isFormSubmittedProvider.notifier).state = true;

                  showDialog(
                    context: context,
                    builder: (context) {
                      return SuccessDialog(
                        message: response.message ?? "Success",
                      );
                    },
                  );

                } else {

                  final errorMessage =
                  (response.error != null && response.error.toString().isNotEmpty)
                      ? response.error.toString()
                      : response.message ?? "Something went wrong";

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(errorMessage)),
                  );
                }
              }
              break;
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
        LoadingWidget(),
      ],
    );
  }

  Widget _mainLayout() {
    //TODO :: auto fill the user information
    final user = ref.read(userProvider);
   //TODO :: name of user autofill
    final nameController =
    TextEditingController(text: user?.name ?? "");
   //TODO :: email  of user autofill
    final emailController =
    TextEditingController(text: user?.email ?? "N/A");
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        clearField();
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorUtils.whiteColor,
        body: Stack(
          children: [
            //TODO :: background image
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
              child: Image.asset(
                dashboardBackgroundImage,
                width: double.infinity,
                height: 0.27.sh,
                fit: BoxFit.cover,
              ),
            ),
            Form(
              key: _formKey,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                  SizedBox(
                  height: 0.23.sh,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 24.w, vertical: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            //TODO :: back arrow icon
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: SvgPicture.asset(
                                backArrow,
                                height: 35.h,
                              ),
                            ),
                            SizedBox(width: 20.w),
                            //TODO :: event text
                            RalewayTextWidget(
                              fontsize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorUtils.whiteColor,
                              text: eventText,
                            ),
                            const Spacer(),
                          ],
                        ),
                        SizedBox(
                          height: 80.h,
                        ),
                        //TODO :: searching text field
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
                                    hintColor: ColorUtils.lightBlackTextColor,
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
                    //TODO :: showing event title location auto fill
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 30.0.w, right: 30.w),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //TODO :: event title
                          RalewayTextWidget(
                            fontsize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorUtils.mediumGrayColor,
                            text: widget.event!.title ?? "N/A",
                          ),
                          SizedBox(height: 10.h),
                          //TODO :: location or speaker
                          RalewayTextWidget(
                            fontsize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: ColorUtils.mediumGrayColor,
                            text: "Location: ${widget.event!.location ??
                                'N/A'} | Speakers: ${widget.event!.speakers ??
                                'N/A'}",
                          ),
                          SizedBox(height: 10.h),
                          //TODO ::name heading text
                          RalewayTextWidget(
                            fontsize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorUtils.mediumGrayColor,
                            text: nameTextHeading,
                          ),
                          SizedBox(height: 10.h),
                          //TODO :: user name text field show
                          CustomTextFieldSplash(
                            controller: nameController,
                            labelText: widget.event!.title ?? "",
                            textInputAction: TextInputAction.done,
                            fontSize: 25.sp,
                            hintColor: ColorUtils.lightBlackTextColor,
                            readOnly: true,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return enterName;
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 10.h),
                          //TODO :: email heading text
                          RalewayTextWidget(
                            fontsize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorUtils.mediumGrayColor,
                            text: emailText,
                          ),
                          SizedBox(height: 10.h),
                          //TODO :: email text field
                          CustomTextFieldSplash(
                            controller: emailController,
                            labelText: "Email",
                            readOnly: false,
                            textInputAction: TextInputAction.done,
                            fontSize: 25.sp,
                            hintColor:
                            ColorUtils.lightBlackTextColor,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return enterName;
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.h),
                          //TODO :: phone heading text
                          RalewayTextWidget(
                            fontsize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorUtils.mediumGrayColor,
                            text: phoneHeading,
                          ),
                          SizedBox(height: 10.h),
                          //TODO ::mobile phone text field
                          CustomTextFieldSplash(
                            controller: _mobileController,
                            labelText: enterMobile,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.phone,
                            fontSize: 25.sp,
                            hintColor:
                            ColorUtils.lightBlackTextColor,
                            validator: (value) {
                              return null;
                            },
                          ),
                          SizedBox(height: 10.h),
                          //TODO ::notes heading
                          RalewayTextWidget(
                            fontsize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorUtils.mediumGrayColor,
                            text: notesHeading,
                          ),
                          SizedBox(height: 10.h),
                          //TODO :: notes text field
                          CustomTextFieldSplash(
                            controller: notesController,
                            labelText: enterNotes,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            fontSize: 25.sp,
                            hintColor:
                            ColorUtils.lightBlackTextColor,
                            validator: (value) {
                              return null;
                            },
                          ),

                          SizedBox(height: 10.h),
                          //TODO :: if fee available then show
                          Visibility(
                            visible:showPaymentSection,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //TODO ::payment heading
                                RalewayTextWidget(
                                  fontsize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.mediumGrayColor,
                                  text: paymentMethodText,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO :: dropdown of payment list
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
                                //TODO :: user select payment method then show
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
                                        return const SizedBox();

                                      return Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            //TODO :: transfer detail
                                            RalewayTextWidget(
                                              fontsize: 18.sp,
                                              fontWeight: FontWeight.w700,
                                              color: ColorUtils.blueColor,
                                              text: transferDetails,
                                            ),
                                            SizedBox(height: 8.h),
                                            //TODO :: detail show
                                            RalewayTextWidget(
                                              fontsize: 15.sp,
                                              fontWeight: FontWeight.w700,
                                              color: ColorUtils.mediumGrayColor,
                                              text: selected.details ?? "N/A",
                                            ),
                                             SizedBox(height: 8.h),
                                            //TODO :: instruction
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
                                SizedBox(height: 10.h),
                                //TODO ::proof picture of transction
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
                                        type: 'payment_proof');
                                  },
                                  child: Center(
                                    child: Stack(
                                      children: [
                                        // Circular Avatar
                                        (ref.watch(pictureOfPaymentProofStateProvider) ==
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
                                            pictureOfPaymentProofStateProvider)
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
                                                  pictureOfPaymentProofStateProvider),
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
                                                          pictureOfPaymentProofStateProvider))))),
                                        )
                                        // Edit Icon positioned at the bottom right
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 10.h,
                          ),
                          //TODO :: elevated button of register a event
                          SizedBox(
                            width: double.infinity,
                            child: CustomElevatedButton(
                              buttonText: registerEvent,
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  if (validateForm()) {
                                    _submitForm();
                                  }
                                }
                              },
                              fontSize: 22.sp,
                              backgroundColor: ColorUtils.greenTextColor,
                              textColor: ColorUtils.whiteColor,
                              borderColor: ColorUtils.greenTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //TODO :: validate form proof image is add or not
  bool validateForm() {
    if (showPaymentSection) {
      final picture = ref.read(pictureOfPaymentProofStateProvider);

      if (picture.isEmpty) {
        Utils.showToast(selectPictureOfTransaction);
        return false;
      }
    }

    return true;
  }
  // :: TODO Save Form to Server
  void _submitForm() async {
    final user = ref.read(userProvider);
    String name =  user?.name ?? "";
    String email = user?.email ?? "";
    String phone = _mobileController.text.trim();
    String notes = notesController.text.trim();
    if (await Utils.isInternetAvailable()) {
      if (widget.event?.id != null) {
        await ref
            .read(apiEventRegisterNotifierProvider.notifier)
            .apiSubmitRegisterEvent(name,email,phone,notes,widget.event!.id,);
      } else {
        Utils.showToast(noInternetText);
        return; // Stop submission
      }

    } else {}
  }
  //TODO :: method of showing payment available or not
  bool get showPaymentSection {
    final feeStr = widget.event?.feeAmount ?? '';

    final cleaned = feeStr.replaceAll(RegExp(r'[^0-9.]'), '');

    final fee = double.tryParse(cleaned) ?? 0;

    return fee > 0;
  }
  //TODO :: clear fields
 clearField(){
    ref.invalidate(pictureOfPaymentProofStateProvider);
    ref.invalidate(selectedTypeOfPaymentMethod);
 }
}
