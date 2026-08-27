import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/providers/api_add_new_book_notifier.dart';
import 'package:flutter_base/route/routes.dart';
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
import '../../models/response/server_response.dart';
import '../../utils/api_state_model.dart';
import '../../widgets/button_widget/success_dialog.dart';
import '../../widgets/custom_drop_down_search.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/drawer_item.dart';
import '../../widgets/poppins_text_widget.dart';

class AddNewBookScreen extends ConsumerStatefulWidget {
  const AddNewBookScreen({super.key});

  @override
  AddNewBookScreenState createState() => AddNewBookScreenState();
}

class AddNewBookScreenState extends ConsumerState<AddNewBookScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();
  final bookTitleController = TextEditingController();
  final donorNameController = TextEditingController();
  final donorEmailController = TextEditingController();
  final authorsController = TextEditingController();
  final pagesController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final copeiesController = TextEditingController();
  final bookEditionController = TextEditingController();
  final authorController = TextEditingController();
  final publisherNameController = TextEditingController();
  final newAuthorNameController = TextEditingController();
  final newCategoryController = TextEditingController();
  final publisherDateController = TextEditingController();
  final isbController = TextEditingController();
  final _mobileController = MaskedTextController(mask: "0000-0000000");
  Timer? _debounce;
  bool isFromGoogleBook = false;
  String selectedPreviewLink = "";
  String selectedPdfLink = "";

  @override
  void initState() {
    super.initState();
    // :: TODO sync data when widgets tree loaded
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getDropDownsData();

      clearFields();

      await _loadLibrary();
    });
  }

  //TODO:: get all data for dropdown author category shelf room or donor
  Future<void> getDropDownsData() async {
    await ref.read(apiAddNewBookNotifierProvider.notifier).getAllAuthors();
    await ref.read(apiAddNewBookNotifierProvider.notifier).getAllCatogies();
    await ref.read(apiAddNewBookNotifierProvider.notifier).getAllShelf();
    await ref.read(apiAddNewBookNotifierProvider.notifier).getAllRoom();
    await ref.read(apiAddNewBookNotifierProvider.notifier).getAllDonor();
  }

//TODO:: load list of library
  Future<void> _loadLibrary() async {
    final savedList = await Utils.getLibrariesList();

    if (savedList.isNotEmpty) {
      ref.read(typeOfLibraryListStateProvider.notifier).state = savedList;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // :: TODO listen api responses
    ref.listen<ApiStatesModel>(apiAddNewBookNotifierProvider,
        (previous, apiStatesModel) {
      switch (apiStatesModel.states) {
        case States.ERROR:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(apiStatesModel.message),
          ));
          break;

        case States.DATA:
          if (apiStatesModel.data is ServerResponse) {
            final _response = apiStatesModel.data as ServerResponse;

            if (!(_response.status ?? false)) {
              final errorMessage =
                  (_response.error != null && _response.error!.isNotEmpty)
                      ? _response.error!.join("\n")
                      : _response.message ?? "Something went wrong";

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(errorMessage),
              ));
            } else {
              // :: Success
              ref.read(isFormSubmittedProvider.notifier).state = true;
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessDialog(
                    message: _response.message ?? "Success",
                  );
                },
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
        clearFields();
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorUtils.whiteColor,
        key: _key,
        body: Stack(children: [
          //TODO:: background image
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
            child: Image.asset(
              dashboardBackgroundImage,
              width: double.infinity,
              height: 0.27.sh,
              fit: BoxFit.fill,
            ),
          ),
          Form(
            key: _formKey, // Assign the _formKey here
            child: SafeArea(
                bottom: false,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TODO :: build app bar widget
                     buildAppBarWidget(),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 30.0.w, right: 30.w),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20.h,
                                ),
                                //TODO:: add new book text
                                RalewayTextWidget(
                                  fontsize: 22.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.mediumGrayColor,
                                  text: addNewBookText,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: book title heading
                                RalewayTextWidget(
                                  fontsize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.mediumGrayColor,
                                  text: bookTitle,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: book title custom text field
                                CustomTextFieldSplash(
                                  controller: bookTitleController,
                                  labelText: titleHint,
                                  textInputAction: TextInputAction.done,
                                  fontSize: 25.sp,
                                  hintColor: ColorUtils.lightBlackTextColor,
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return enterTitle;
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: book title heading
                                RalewayTextWidget(
                                  fontsize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.mediumGrayColor,
                                  text: editionTitle,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: book title text field
                                CustomTextFieldSplash(
                                  controller: bookEditionController,
                                  labelText: editionHint,
                                  textInputAction: TextInputAction.done,
                                  fontSize: 25.sp,
                                  hintColor: ColorUtils.lightBlackTextColor,
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return enterEdition;
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: isbn heading
                                RalewayTextWidget(
                                  fontsize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.mediumGrayColor,
                                  text: isbnNumber,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO::isbn text field
                                CustomTextFieldSplash(
                                  controller: isbController,
                                  labelText: isbnHint,
                                  textInputAction: TextInputAction.done,
                                  fontSize: 25.sp,
                                  hintColor: ColorUtils.lightBlackTextColor,
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return enterISBN;
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  children: [
                                    //TODO:: publisher name heading
                                    Expanded(
                                      child: RalewayTextWidget(
                                        fontsize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: ColorUtils.mediumGrayColor,
                                        text: publisherName,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  children: [
                                    //TODO:: publisher name text field
                                    Expanded(
                                      child: CustomTextFieldSplash(
                                        controller: publisherNameController,
                                        labelText: publisherNameHint,
                                        textInputAction: TextInputAction.done,
                                        fontSize: 25.sp,
                                        hintColor:
                                            ColorUtils.lightBlackTextColor,
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return enterPublisherName;
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Visibility(
                                        visible: false,
                                        child: SizedBox(width: 23.w)),
                                    //TODO:: publisher date text field
                                    Visibility(
                                      visible: false,
                                      child: Expanded(
                                        child: CustomTextFieldSplash(
                                          controller: publisherDateController,
                                          labelText: publishDateHint,
                                          readOnly: true,
                                          hintColor:
                                              ColorUtils.lightBlackTextColor,
                                          isDateField: true,
                                          keyboardType: TextInputType.datetime,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime(2100),
                                            );

                                            if (pickedDate != null) {
                                              publisherDateController.text =
                                                  "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: publisher date hint heading
                                RalewayTextWidget(
                                  fontsize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.mediumGrayColor,
                                  text: publishDateHint,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: publisher date text field
                                CustomTextFieldSplash(
                                  controller: publisherDateController,
                                  labelText: publishDateHint,
                                  readOnly: true,
                                  hintColor: ColorUtils.lightBlackTextColor,
                                  isDateField: true,
                                  keyboardType: TextInputType.datetime,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100),
                                    );

                                    if (pickedDate != null) {
                                      publisherDateController.text =
                                          "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: author type heading
                                RalewayTextWidget(
                                  fontsize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.mediumGrayColor,
                                  text: authorTypeText,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: dropdown of author
                                CustomDropdownSearch(
                                  showSearchBox: false,
                                  items:
                                      ref.watch(typeOfAuthorListStateProvider),
                                  selectedItem: ref.watch(selectedTypeOfAuthor),
                                  onChanged: (selectedItem) {
                                    ref
                                        .read(selectedTypeOfAuthor.notifier)
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
                                      return selectTypeOfAurhor;
                                    } else if (value.name == null ||
                                        value.name!
                                            .toLowerCase()
                                            .contains("please")) {
                                      return selectTypeOfAurhor;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                //TODO:: user select other thne showing
                                Visibility(
                                  visible:
                                      ref.watch(selectedTypeOfAuthor)?.name ==
                                          "Other (Add new)",
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //TODO:: new author name text
                                      RalewayTextWidget(
                                        fontsize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: ColorUtils.mediumGrayColor,
                                        text: newAuthorName,
                                      ),
                                      //TODO:: new author text field
                                      CustomTextFieldSplash(
                                        controller: newAuthorNameController,
                                        labelText: authorName,
                                        textInputAction: TextInputAction.done,
                                        fontSize: 25.sp,
                                        hintColor:
                                            ColorUtils.lightBlackTextColor,
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return enterAuthorName;
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: library text heading
                                RalewayTextWidget(
                                  fontsize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.mediumGrayColor,
                                  text: libraryTypeText,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: dropdown of library
                                CustomDropdownSearch(
                                  showSearchBox: false,
                                  items:
                                      ref.watch(typeOfLibraryListStateProvider),
                                  selectedItem:
                                      ref.watch(selectedTypeOfLibrary),
                                  onChanged: (selectedItem) {
                                    ref
                                        .read(selectedTypeOfLibrary.notifier)
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
                                    // Check if value is null before trying to access its properties
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
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: category type heading
                                RalewayTextWidget(
                                  fontsize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.mediumGrayColor,
                                  text: categoryTypeText,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO::dropdown of category
                                CustomDropdownSearch(
                                  showSearchBox: false,
                                  items: ref
                                      .watch(typeOfCategoryListStateProvider),
                                  selectedItem:
                                      ref.watch(selectedTypeOfCategory),
                                  onChanged: (selectedItem) {
                                    ref
                                        .read(selectedTypeOfCategory.notifier)
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
                                    // Check if value is null before trying to access its properties
                                    if (value == null) {
                                      return selectCategory;
                                    } else if (value.name == null ||
                                        value.name!
                                            .toLowerCase()
                                            .contains("please")) {
                                      return selectCategory;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                //TODO:: user select other then show
                                Visibility(
                                  visible:
                                      ref.watch(selectedTypeOfCategory)?.name == "Other (Add new)",
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //TODO:: new category heading text
                                      RalewayTextWidget(
                                        fontsize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: ColorUtils.mediumGrayColor,
                                        text: newCategory,
                                      ),
                                      //TODO:: field of new category text field
                                      CustomTextFieldSplash(
                                        controller: newCategoryController,
                                        labelText: categoryName,
                                        textInputAction: TextInputAction.done,
                                        fontSize: 25.sp,
                                        hintColor:
                                            ColorUtils.lightBlackTextColor,
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return enterCategoryName;
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: room type text heading
                                RalewayTextWidget(
                                  fontsize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.mediumGrayColor,
                                  text: roomTypeText,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: dropdown of room
                                CustomDropdownSearch(
                                  showSearchBox: false,
                                  items: ref.watch(typeOfRoomListStateProvider),
                                  selectedItem: ref.watch(selectedTypeOfRoom),
                                  onChanged: (selectedItem) {
                                    ref
                                        .read(selectedTypeOfRoom.notifier)
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
                                    // Check if value is null before trying to access its properties
                                    if (value == null) {
                                      return selectTypeRoom;
                                    } else if (value.name == null ||
                                        value.name!
                                            .toLowerCase()
                                            .contains("please")) {
                                      return selectTypeRoom;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: shelf text heading
                                RalewayTextWidget(
                                  fontsize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.mediumGrayColor,
                                  text: shelfText,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: dropdown list of book shelf
                                CustomDropdownSearch(
                                  showSearchBox: false,
                                  items:
                                      ref.watch(typeOfShelfListStateProvider),
                                  selectedItem: ref.watch(selectedTypeOfShelf),
                                  onChanged: (selectedItem) {
                                    ref
                                        .read(selectedTypeOfShelf.notifier)
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
                                    // Check if value is null before trying to access its properties
                                    if (value == null) {
                                      return selectTypeRoom;
                                    } else if (value.name == null ||
                                        value.name!
                                            .toLowerCase()
                                            .contains("please")) {
                                      return selectTypeRoom;
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: price text heading
                                RalewayTextWidget(
                                  fontsize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.mediumGrayColor,
                                  text: priceTitle,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: price text field
                                CustomTextFieldSplash(
                                  controller: priceController,
                                  labelText: priceTitle,
                                  textInputAction: TextInputAction.done,
                                  fontSize: 25.sp,
                                  hintColor: ColorUtils.lightBlackTextColor,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return enterPrice; // "Please enter copies"
                                    }

                                    // Check if the input is a number
                                    final int? number = int.tryParse(value);
                                    if (number == null) {
                                      return validPrice;
                                    }
                                    if (number <= 0) {
                                      return numberOfPrice;
                                    }

                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: number of copies heading text
                                RalewayTextWidget(
                                  fontsize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.mediumGrayColor,
                                  text: numberOfCopes,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: copies text filed
                                CustomTextFieldSplash(
                                  controller: copeiesController,
                                  labelText: numberOfCopes,
                                  textInputAction: TextInputAction.done,
                                  fontSize: 25.sp,
                                  hintColor: ColorUtils.lightBlackTextColor,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return enterCopies; // "Please enter copies"
                                    }

                                    // Check if the input is a number
                                    final int? number = int.tryParse(value);
                                    if (number == null) {
                                      return validCopies;
                                    }
                                    if (number <= 0) {
                                      return numberOfCopies;
                                    }

                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: summary text heading
                                RalewayTextWidget(
                                  fontsize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.mediumGrayColor,
                                  text: summaryTitle,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //TODO:: description text field
                                CustomTextFieldSplash(
                                  controller: descriptionController,
                                  labelText: description,
                                  textInputAction: TextInputAction.done,
                                  fontSize: 25.sp,
                                  hintColor: ColorUtils.lightBlackTextColor,
                                  keyboardType: TextInputType.visiblePassword,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return enterDetail;
                                    }
                                    return null;
                                  },
                                ),
                                //TODO:: is donated check box
                                CheckboxListTile(
                                  title: PoppinsTextWidget(
                                    fontsize: 18.sp,
                                    fontWeight: FontWeight.w400,
                                    color: ColorUtils.blackColor,
                                    text: isDonatedText,
                                    textAlign: TextAlign.start,
                                  ),
                                  value: ref.watch(isDonatedCbProvider),
                                  onChanged: (newValue) {
                                    if (newValue!) {
                                      ref
                                          .read(
                                              isDonatedValueCbProvider.notifier)
                                          .state = 1;
                                    } else {
                                      ref.refresh(isDonatedValueCbProvider);
                                    }
                                    _mobileController.clear();
                                    donorEmailController.clear();
                                    donorNameController.clear();
                                    ref.refresh(selectedTypeOfDonor);
                                    ref
                                        .read(isDonatedCbProvider.notifier)
                                        .state = newValue!;
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity: ListTileControlAffinity
                                      .leading, //  <-- leading Checkbox
                                ),
                                //TODO:: when user check is donated then showing
                                Visibility(
                                    visible: ref.watch(isDonatedCbProvider),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //TODO:: donor information text heading
                                        RalewayTextWidget(
                                          fontsize: 22.sp,
                                          fontWeight: FontWeight.w700,
                                          color: ColorUtils.greenTextColor,
                                          text: donorInformation,
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        //TODO::donor type heading text
                                        RalewayTextWidget(
                                          fontsize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          color: ColorUtils.mediumGrayColor,
                                          text: donorTypeText,
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        //TODO::dropdown of donor
                                        CustomDropdownSearch(
                                          showSearchBox: false,
                                          items: ref.watch(
                                              typeOfDonorListStateProvider),
                                          selectedItem:
                                              ref.watch(selectedTypeOfDonor),
                                          onChanged: (selectedItem) {
                                            ref
                                                .read(selectedTypeOfDonor
                                                    .notifier)
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
                                            // Check if value is null before trying to access its properties
                                            if (value == null) {
                                              return selectTypeOfDonor;
                                            } else if (value.name == null ||
                                                value.name!
                                                    .toLowerCase()
                                                    .contains("please")) {
                                              return selectTypeOfDonor;
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                      ],
                                    )),
                                //TODO:: user select other then showing
                                Visibility(
                                  visible:
                                      ref.watch(selectedTypeOfDonor)?.name ==
                                          "Add New Donor",
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //TODO:: new donor name heading text
                                      RalewayTextWidget(
                                        fontsize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: ColorUtils.mediumGrayColor,
                                        text: donorNameHint,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      //TODO:: new donor name text field
                                      CustomTextFieldSplash(
                                        controller: donorNameController,
                                        labelText: donorNameHint,
                                        textInputAction: TextInputAction.done,
                                        fontSize: 25.sp,
                                        hintColor:
                                            ColorUtils.lightBlackTextColor,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return enterDonor;
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      //TODO:: donor email text heading
                                      RalewayTextWidget(
                                        fontsize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: ColorUtils.mediumGrayColor,
                                        text: emailPhoneText,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      //TODO:: donor email text field
                                      CustomTextFieldSplash(
                                        controller: donorEmailController,
                                        labelText: enterEmail,
                                        textInputAction: TextInputAction.done,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        fontSize: 25.sp,
                                        hintColor:
                                            ColorUtils.lightBlackTextColor,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return enterEmailError;
                                          }
                                          final emailRegex =
                                              RegExp(emailFormat);
                                          if (!emailRegex.hasMatch(value)) {
                                            return emailFormatError;
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      //TODO::new donor phone number heading text
                                      RalewayTextWidget(
                                        fontsize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                        color: ColorUtils.mediumGrayColor,
                                        text: phoneNumberText,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      //TODO:: new donor phone number text field
                                      CustomTextFieldSplash(
                                        controller: _mobileController,
                                        labelText: enterMobile,
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.phone,
                                        fontSize: 25.sp,
                                        hintColor:
                                            ColorUtils.lightBlackTextColor,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return enterMobileError;
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 20.h,
                                ),
                                //TODO:: elevated button of adding/creating new book
                                SizedBox(
                                  width: double.infinity,
                                  child: CustomElevatedButton(
                                    buttonText: bookAdded,
                                    onPressed: () async {
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        onSubmitForm();
                                      } //
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
                    ])),
          )
        ]),
      ),
    );
  }

//TODO:: search dialog open when user search book and showing list of books
  void openSearchDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(bookSearchProvider);

            return AlertDialog(
              //TODO:: search result text heading
              title: RalewayTextWidget(
                fontsize: 12.sp,
                fontWeight: FontWeight.w700,
                color: ColorUtils.blackColor,
                text: searchBookResultText,
                maxLines: 2,
              ),
              //TODO :: list of books showing
              content: SizedBox(
                width: 0.9.sw,
                height: 0.6.sh,
                child: state.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text("Error: $err")),
                  data: (books) {
                    if (books.isEmpty) {
                      return const Center(child: Text(noBook));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return ListTile(
                          leading: book.thumbnail.isNotEmpty
                              ? Image.network(book.thumbnail, width: 40)
                              : const Icon(Icons.book),
                          //TODO :: book title
                          title: RalewayTextWidget(
                            fontsize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: ColorUtils.blackColor,
                            text: book.title,
                            maxLines: 2,
                          ),
                          //TODO :: book subtitle
                          subtitle: RalewayTextWidget(
                            fontsize: 11.sp,
                            fontWeight: FontWeight.w300,
                            color: ColorUtils.blackColor,
                            text: book.subtitle,
                            maxLines: 2,
                          ),
                          //TODO ::on this showing book title subtitle description edition name of publisher ibn author copies price of book
                          onTap: () {
                            bookTitleController.text = book.title;
                            descriptionController.text = book.description;
                            bookEditionController.text = book.edition;
                            publisherNameController.text = book.publisher;
                            publisherDateController.text = book.publishedDate;
                            isbController.text = book.isbn;
                            authorsController.text = book.authors;
                            copeiesController.text = book.copies;
                            priceController.text = book.price;
                            // selectedPreviewLink = book.previewLink ?? "";
                            // selectedPdfLink = book.pdfDownloadLink ?? "";
                            // print("pdf link $selectedPdfLink");
                            // print("preview link $selectedPreviewLink");
                            // isFromGoogleBook = true;
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

//TODO :: api call for submitting or creating new book
  void onSubmitForm() async {
    String bookTitle = bookTitleController.text.trim();
    String edition = bookEditionController.text.trim();
    String isbnNumber = isbController.text.trim();
    String publisherName = publisherNameController.text.trim();
    String publisherDate = publisherDateController.text;
    String priceText = priceController.text.trim();
    String copiesText = copeiesController.text.trim();
    String summary = descriptionController.text.trim();
    int price = int.tryParse(priceText) ?? 0;
    int copies = int.tryParse(copiesText) ?? 0;
    String donorName = donorNameController.text;
    String donorEmail = donorEmailController.text;
    String donorPhone = _mobileController.text;
    String newCategory = newCategoryController.text;
    String newAuthorName = newAuthorNameController.text;
    // bool isFromGoogleBook = false;
    // String previewLink = selectedPreviewLink;
    // String pdfLink = selectedPdfLink;

    if (await Utils.isInternetAvailable()) {
      await ref
          .read(apiAddNewBookNotifierProvider.notifier)
          .apiSubmitCreateBookForm(
            bookTitle,
            isbnNumber,
            edition,
            publisherName,
            publisherDate,
            price,
            copies,
            summary,
            donorName,
            donorEmail,
            donorPhone,
            newCategory,
            newAuthorName,
            // isFromGoogleBook: isFromGoogleBook,
            // previewLink,
            // pdfLink,
          );
    } else {
      Utils.showToast(noInternetText);
      return; // Stop submission
    }
  }
//TODO ::Widget app bar widget add new book text or filter icon search
  Widget buildAppBarWidget(){
    return Column(children: [
      SizedBox(
        height: 0.23.sh,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 24.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //TODO:: back arrow iocn
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
                  //TODO:: add new book text heading
                  RalewayTextWidget(
                    fontsize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorUtils.whiteColor,
                    text: addNewBookText,
                  ),
                ],
              ),
              SizedBox(
                height: 80.h,
              ),
              //TODO:: search text field
              Row(
                children: [
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 50.h,
                        maxHeight: 50.h,
                      ),
                      child: CustomTextFieldSplash(
                        controller: searchController,
                        labelText: "Search book",
                        isSearchField: false,
                        // prefixIconWidget: Icon(
                        //   Icons.search,
                        //   size: 20.sp,
                        //   color: ColorUtils.lightBlackTextColor,
                        // ),
                        onChanged: (value) {
                          if (_debounce?.isActive ?? false)
                            _debounce!.cancel();

                          _debounce = Timer(
                              const Duration(milliseconds: 800),
                                  () {
                                ref
                                    .read(
                                    bookSearchProvider.notifier)
                                    .searchBooks(value);
                              });
                        },
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  //TODO:: filter icon
                  SizedBox(width: 10.w),
                  InkWell(
                    onTap: () {
                      if (searchController.text.isNotEmpty) {
                        ref
                            .read(bookSearchProvider.notifier)
                            .searchBooks(searchController.text);
                      }
                      openSearchDialog();
                    },
                    child: Container(
                      width: 56.w,
                      height: 51.h,
                      decoration: BoxDecoration(
                        color: ColorUtils.whiteColor,
                        borderRadius:
                        BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.search,
                          color: ColorUtils.greenTextColor,
                          size: 26.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],);
  }
//TODO :: clear fields
  void clearFields() {
    ref.refresh(selectedTypeOfShelf);
    ref.refresh(selectedTypeOfCategory);
    ref.refresh(selectedTypeOfRoom);
    ref.refresh(selectedTypeOfLibrary);
    ref.refresh(selectedTypeOfAuthor);
    ref.read(isDonatedCbProvider.notifier).state = false;
    ref.read(isDonatedValueCbProvider.notifier).state = 0;
    ref.refresh(selectedTypeOfDonor);
  }
}
