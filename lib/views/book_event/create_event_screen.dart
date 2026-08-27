import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/models/request/event_register/CreateEventRequest.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_base/utils/image_assets.dart';
import 'package:flutter_base/utils/strings.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/dialog_widget/dialog_widget.dart';
import 'package:flutter_base/widgets/loading_widget.dart';
import 'package:flutter_base/widgets/raleway_text_widget.dart';
import 'package:flutter_base/widgets/text_field_widget/custom_text_field_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../models/response/server_response.dart';
import '../../providers/api_create_event_notifier.dart';
import '../../utils/api_state_model.dart';
import '../../widgets/button_widget/success_dialog.dart';
import '../../widgets/custom_drop_down_search.dart';
import '../../widgets/custom_elevated_button.dart';

class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  CreateEventScreenState createState() => CreateEventScreenState();
}

class CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final searchController = TextEditingController();
  final descriptionController = TextEditingController();
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final speakerController = TextEditingController();
  final feeController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DateTime issueDate = DateTime.now();
  DateTime? dueDate;

  String? role;
  bool canAddBook = false;

  @override
  void initState() {
    super.initState();
    // :: TODO sync data when widgets tree loaded
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      refreshField();
      getDropDownsData();
      await _loadLibrary();
    });
  }
//TODO :: showing payment method dropdown list
  Future<void> getDropDownsData() async {
    await ref
        .read(apiCreateEventNotifierProvider.notifier)
        .getAllPaymentMethod();
    // await ref.read(apiSubscriptionDetailNotifierProvider.notifier).getAllPlatform();
  }
//TODO :: load all library dropdown list
  Future<void> _loadLibrary() async {
    final savedList = await Utils.getLibrariesList();

    if (savedList.isNotEmpty) {
      ref.read(typeOfLibraryListStateProvider.notifier).state = savedList;
      // ref.read(selectedTypeOfPaymentMethod.notifier).state = savedList.first;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // :: TODO listen api responses
    ref.listen<ApiStatesModel>(apiCreateEventNotifierProvider,
        (previous, apiStatesModel) {
      switch (apiStatesModel.states) {
        case States.ERROR:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(apiStatesModel.message),
          ));
          break;
        case States.DATA:
          if (apiStatesModel.data is ServerResponse) {
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
              final errorMessage = (response.error != null &&
                      response.error.toString().isNotEmpty)
                  ? response.error.toString()
                  : response.message ?? "Something went wrong";

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorMessage)),
              );
            }
          }
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        refreshField();
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
                height: 0.27.sh,
                width: double.infinity,
                fit: BoxFit.cover,
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
                          SizedBox(
                            height: 30.h,
                          ),
                          //TODO ::back arrow
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
                              //TODO :: add event text
                              RalewayTextWidget(
                                fontsize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.whiteColor,
                                text: addEventText,
                              ),
                              const Spacer(),
                            ],
                          ),
                          SizedBox(
                            height: 70.h,
                          ),
                          //TODO ::showing search text field
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
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 15.0.w, right: 15.w),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //TODO :: add event text heading
                                  RalewayTextWidget(
                                    fontsize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: ColorUtils.mediumGrayColor,
                                    text: addEventText,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              //TODO :: library text heaading
                              RalewayTextWidget(
                                fontsize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.mediumGrayColor,
                                text: libraryTypeText,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              //TODO :: dropdown of library
                              CustomDropdownSearch(
                                showSearchBox: false,
                                items:
                                    ref.watch(typeOfLibraryListStateProvider),
                                selectedItem: ref.watch(selectedTypeOfLibrary),
                                onChanged: (selectedItem) {
                                  ref
                                      .read(selectedTypeOfLibrary.notifier)
                                      .state = selectedItem!;
                                },
                                itemAsString: (typeOfIndustry) {
                                  if (typeOfIndustry == null) {
                                    return "Not selected";
                                  } else {
                                    return typeOfIndustry.name ?? "--select--";
                                  }
                                },
                                onValidate: (value) {
                                  //TODO :: Check if value is null before trying to access its properties
                                  if (value == null) {
                                    return selectTypeOfLibrary;
                                  } else if (value.name == null ||
                                      value.name!
                                          .toLowerCase()
                                          .contains("please")) {
                                    return selectTypeOfLibrary;
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(height: 5.h),
                              //TODO :: event title heading text
                              RalewayTextWidget(
                                fontsize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.mediumGrayColor,
                                text: eventTitleHeading,
                              ),
                              SizedBox(height: 10.h),
                              //TODO ::text field for title event
                              CustomTextFieldSplash(
                                controller: titleController,
                                labelText: eventTitle,
                                textInputAction: TextInputAction.done,
                                fontSize: 25.sp,
                                hintColor: ColorUtils.lightBlackTextColor,
                                readOnly: false,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return enterTitleText;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 10.h),
                              //TODO :: description text
                              RalewayTextWidget(
                                fontsize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.mediumGrayColor,
                                text: description,
                              ),
                              SizedBox(height: 10.h),
                              //TODO :: text field of description
                              CustomTextFieldSplash(
                                controller: descriptionController,
                                labelText: eventDescription,
                                textInputAction: TextInputAction.done,
                                fontSize: 25.sp,
                                hintColor: ColorUtils.lightBlackTextColor,
                                readOnly: false,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              SizedBox(height: 10.h),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  //TODO :: location text heading
                                  Expanded(
                                    child: RalewayTextWidget(
                                      fontsize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorUtils.mediumGrayColor,
                                      text: locationText,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  //TODO :: speaker text heading
                                  Expanded(
                                    child: RalewayTextWidget(
                                      fontsize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorUtils.mediumGrayColor,
                                      text: speakerText,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10.h),

                              Row(
                                children: [
                                  //TODO :: text field of location
                                  Expanded(
                                    child: CustomTextFieldSplash(
                                      controller: locationController,
                                      labelText: eventLocation,
                                      textInputAction: TextInputAction.done,
                                      fontSize: 25.sp,
                                      hintColor: ColorUtils.lightBlackTextColor,
                                      readOnly: false,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  //TODO :: text field of speaker
                                  Expanded(
                                    child: CustomTextFieldSplash(
                                      controller: speakerController,
                                      labelText: mainSpeakerText,
                                      textInputAction: TextInputAction.done,
                                      fontSize: 25.sp,
                                      hintColor: ColorUtils.lightBlackTextColor,
                                      readOnly: false,
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //TODO :: event fee text heading
                                  Expanded(
                                    child: RalewayTextWidget(
                                      fontsize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorUtils.mediumGrayColor,
                                      text: eventFee,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              //TODO :: text field of fee amount
                              CustomTextFieldSplash(
                                controller: feeController,
                                labelText: amount,
                                textInputAction: TextInputAction.done,
                                fontSize: 25.sp,
                                hintColor: ColorUtils.lightBlackTextColor,
                                readOnly: false,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  return null;
                                },
                              ),
                              SizedBox(height: 10.h),
                              //TODO :: start DATE
                              Row(
                                children: [
                                  Expanded(
                                    child: RalewayTextWidget(
                                      text: endDateText,
                                      fontsize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorUtils.mediumGrayColor,
                                    ),
                                  ),
                                  //TODO ::DUE DATE
                                  Expanded(
                                    child: RalewayTextWidget(
                                      text: startDateText,
                                      fontsize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorUtils.mediumGrayColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //TODO :: start date text field
                                  Expanded(
                                    child: CustomTextFieldSplash(
                                      labelText: dateHint,
                                      controller: startDateController,
                                      isDateField: true,
                                      readOnly: true,
                                      keyboardType: TextInputType.datetime,
                                      hintColor: ColorUtils.lightBlackTextColor,
                                      onTap: () async {
                                        final pickedDate = await showDatePicker(
                                          context: context,
                                          initialDate: issueDate,
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2100),
                                        );

                                        if (pickedDate != null) {
                                          final pickedTime =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );

                                          if (pickedTime != null) {
                                            final finalDateTime = DateTime(
                                              pickedDate.year,
                                              pickedDate.month,
                                              pickedDate.day,
                                              pickedTime.hour,
                                              pickedTime.minute,
                                            );

                                            setState(() {
                                              issueDate = finalDateTime;

                                              startDateController.text =
                                                  "${finalDateTime.year}-"
                                                  "${finalDateTime.month.toString().padLeft(2, '0')}-"
                                                  "${finalDateTime.day.toString().padLeft(2, '0')} "
                                                  "${finalDateTime.hour.toString().padLeft(2, '0')}:"
                                                  "${finalDateTime.minute.toString().padLeft(2, '0')}";
                                            });
                                          }
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return selectStartDate;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  //TODO :: end date text field
                                  Expanded(
                                    child: CustomTextFieldSplash(
                                      labelText: dateHint,
                                      controller: endDateController,
                                      isDateField: true,
                                      readOnly: true,
                                      keyboardType: TextInputType.datetime,
                                      hintColor: ColorUtils.lightBlackTextColor,
                                      onTap: () async {
                                        final pickedDate = await showDatePicker(

                                          context: context,
                                          initialDate: DateTime.now()
                                              .add(const Duration(days: 1)),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2100),
                                        );

                                        if (pickedDate != null) {
                                          final pickedTime =
                                              await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );

                                          if (pickedTime != null) {
                                            final finalDateTime = DateTime(
                                              pickedDate.year,
                                              pickedDate.month,
                                              pickedDate.day,
                                              pickedTime.hour,
                                              pickedTime.minute,
                                            );

                                            setState(() {
                                              dueDate = finalDateTime;

                                              endDateController.text =
                                                  "${finalDateTime.year}-"
                                                  "${finalDateTime.month.toString().padLeft(2, '0')}-"
                                                  "${finalDateTime.day.toString().padLeft(2, '0')} "
                                                  "${finalDateTime.hour.toString().padLeft(2, '0')}:"
                                                  "${finalDateTime.minute.toString().padLeft(2, '0')}";
                                            });
                                          }
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return selectEndDate;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              //TODO :: payment method heading text
                              RalewayTextWidget(
                                fontsize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.mediumGrayColor,
                                text: paymentMethodText,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              //TODO :: dropdown of payment methods
                              CustomDropdownSearch(
                                showSearchBox: false,
                                items:
                                    ref.watch(typeOfPaymentListStateProvider),
                                selectedItem:
                                    ref.watch(selectedTypeOfPaymentMethod),
                                onChanged: (selectedItem) {
                                  ref
                                      .read(
                                          selectedTypeOfPaymentMethod.notifier)
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
                                },
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              //TODO :: user select payment method then sowing
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
                                    final selected =
                                        ref.watch(selectedTypeOfPaymentMethod);
                                    if (selected == null)
                                      return const SizedBox();

                                    return Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //TODO :: transfer detail text
                                          RalewayTextWidget(
                                            fontsize: 18.sp,
                                            fontWeight: FontWeight.w700,
                                            color: ColorUtils.blueColor,
                                            text: transferDetails,
                                          ),
                                          SizedBox(height: 8.h),
                                          //TODO :: detail showing
                                          RalewayTextWidget(
                                            fontsize: 15.sp,
                                            fontWeight: FontWeight.w700,
                                            color: ColorUtils.mediumGrayColor,
                                            text: selected.details ?? "N/A",
                                          ),
                                          const SizedBox(height: 8),
                                          //TODO :: instruction showing
                                          RalewayTextWidget(
                                            fontsize: 15.sp,
                                            fontWeight: FontWeight.w700,
                                            color: ColorUtils.mediumGrayColor,
                                            text:
                                                selected.instructions ?? "N/A",
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
                              //TODO :: elevated button add new event
                              SizedBox(
                                width: double.infinity,
                                child: CustomElevatedButton(
                                  buttonText: addEventText,
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      _createEvent();
                                      ();
                                    }
                                  },
                                  backgroundColor: ColorUtils.lightGreenColor,
                                  borderColor: ColorUtils.lightGreenColor,
                                  textColor: ColorUtils.whiteColor,
                                  height: 80.h,
                                  fontSize: 28.sp,
                                ),
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
//TODO :: get initials
  String getInitials(String title) {
    if (title.isEmpty) return "NA";

    List<String> words = title.trim().split(" ");

    if (words.length >= 2) {
      return words[0][0].toUpperCase() + words[1][0].toUpperCase();
    } else {
      return title.length >= 2
          ? title.substring(0, 2).toUpperCase()
          : title.toUpperCase();
    }
  }
//TODO :: first 2 alphabetical of title
  Widget initialsAvatar(String title) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorUtils.lightYellow,
        borderRadius: BorderRadius.circular(0),
      ),
      child: RalewayTextWidget(
        fontsize: 16.sp,
        fontWeight: FontWeight.w800,
        color: ColorUtils.blackColor,
        text: getInitials(title),
      ),
    );
  }
  //TODO :: clear fields
  void refreshField() {
    // await ref.refresh(apiDashboardNotifierProvider.notifier).fetchBooksByLibrary(selectedLibrary!.id!);
    ref.refresh(bookBorrowedProvider.notifier).state;
    ref.refresh(selectedTypeOfPaymentMethod.notifier).state;
    ref.refresh(selectedTypeOfLibrary.notifier).state;
  }

  // :: TODO create event api
  void _createEvent() async {
    if (await Utils.isInternetAvailable()) {
      final selectedPayment = ref.watch(selectedTypeOfPaymentMethod);
      String title = titleController.text;
      String description = descriptionController.text;
      String startDate = startDateController.text;
      String endDate = endDateController.text;
      String location = locationController.text;
      String speaker = speakerController.text;
      String fee = feeController.text;
      CreateEventRequestModel requestModel = CreateEventRequestModel(
        libraryId: ref.read(selectedTypeOfLibrary)!.id!,
        bankName: ref.read(selectedTypeOfPaymentMethod)!.name ?? "",
        bankAccount: selectedPayment.details ?? "",
        title: title,
        description: description,
        startDate: startDate,
        feeAmount: fee,
        endDate: endDate,
        location: location,
        speakers: speaker,
      );
      ref
          .read(apiCreateEventNotifierProvider.notifier)
          .apiCreateEvent(requestModel);
    } else {
      Utils.showToast(networkErrorMessage);
    }
  }
}
