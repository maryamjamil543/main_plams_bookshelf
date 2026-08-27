import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/models/response/server_response.dart';
import 'package:flutter_base/models/response/sync/SyncResponse.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/providers/api_add_new_book_notifier.dart';
import 'package:flutter_base/providers/api_detail_book_notifier.dart';
import 'package:flutter_base/repository/auth_repository.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_base/utils/image_assets.dart';
import 'package:flutter_base/utils/strings.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/dialog_widget/dialog_widget.dart';
import 'package:flutter_base/widgets/loading_widget.dart';
import 'package:flutter_base/widgets/raleway_text_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/response/book_response/Book.dart';
import '../../models/response/login_response/Data.dart';
import '../../utils/api_state_model.dart';
import '../../widgets/button_widget/success_dialog.dart';
import '../../widgets/custom_drop_down_search.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/text_field_widget/custom_text_field_splash.dart';

class DetailBookScreen extends ConsumerStatefulWidget {
  final Book? bookJson;

  const DetailBookScreen({super.key, this.bookJson});

  @override
  DetailBookScreenState createState() => DetailBookScreenState();
}

class DetailBookScreenState extends ConsumerState<DetailBookScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final searchController = TextEditingController();
  final bookTitleController = TextEditingController();
  final bookEditionController = TextEditingController();
  final authorController = TextEditingController();
  final publisherNameController = TextEditingController();
  final publisherDateController = TextEditingController();
  final isbController = TextEditingController();
  String? role;
  bool canAddBook = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //TODO :: permission bases data show
      final Data? userData = await Utils.getUserData();
      if (mounted) {
        setState(() {
          canAddBook =Utils.canAddBookFromUserData(userData);
        });
      }
      if (canAddBook) {
        if (await Utils.isInternetAvailable()) {

            await ref
                .read(apiDetailBookNotifierProvider.notifier)
                .fetchUserAssignBooks();
          } else {
            Utils.showToast(networkErrorMessage);
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
    ref.listen<ApiStatesModel>(apiDetailBookNotifierProvider,
        (previous, apiStatesModel) {
      switch (apiStatesModel.states) {
        case States.ERROR:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(apiStatesModel.message),
          ));
          break;
        case States.DATA:
          if (apiStatesModel.data is SyncResponse) {
            final _response = apiStatesModel.data as SyncResponse;
            if (!(_response).status!) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(apiStatesModel.message),
              ));
              // }
            } else {
              if (_response.data != null) {
                Fluttertoast.showToast(
                    msg: _response.message!, toastLength: Toast.LENGTH_SHORT);
                // }
              } else {}
            }
          }else if (apiStatesModel.data is ServerResponse) {

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
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorUtils.whiteColor,
        // key: _key,
        body: Stack(
          children: [
            // :: TODO background image
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
              child: Image.asset(
                dashboardBackgroundImage,
                height: 260.h,
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
                    height: 0.22.sh,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 34.w, vertical: 34.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // :: TODO back arrow
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
                              // :: TODO  book detail text
                              RalewayTextWidget(
                                fontsize: 24.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.whiteColor,
                                text: bookDetailText,
                              ),
                              const Spacer(),
                              // :: TODO  book share
                              GestureDetector(
                                onTap: () {
                                  final book = widget.bookJson;

                                  if (book != null) {
                                    final shareText = '''
📚 ${book.title}
              
              ✍️ Author: ${book.author?.name ?? "N/A"}
              📅 Year: ${book.publishedYear ?? "N/A"}
              
              ${book.description ?? ""}
              ''';

                                    Share.share(shareText); // 🔥 MAIN FUNCTION
                                  }
                                },
                                child: SvgPicture.asset(
                                  shareIcon,
                                  height: 35.h,
                                ),
                              ),
                              // :: TODO  books added in favorites
                              SizedBox(width: 10.w),
                              InkWell(
                                onTap: () async {
                                  final book = widget.bookJson;

                                  if (book != null) {
                                    final added = await ref
                                        .read(authRepository)
                                        .addFavoriteBook(book);

                                    if (added) {
                                      Fluttertoast.showToast(
                                        msg:addedToFavorites,
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: alreadyFavorites,
                                        backgroundColor: ColorUtils.textColor3,
                                      );
                                    }

                                    Navigator.pop(context);
                                  }
                                },
                                //TODO:: save in favorites
                                child: SvgPicture.asset(
                                  saveIcon,
                                  height: 35.h,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  //TODO::  book detail show publisher title
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0.w, right: 20.w),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //TODO::  image available showing otherwise title base image show
                                (widget.bookJson?.coverImage != null &&
                                        widget.bookJson!.coverImage!.isNotEmpty)
                                    ? Container(
                                  decoration: BoxDecoration(
                                    color: ColorUtils.lightGrey,
                                    borderRadius: BorderRadius.circular(8.r)
                                  ),
                                        child: Padding(
                                          padding: EdgeInsets.all(5.w),
                                          child: Image.network(
                                            widget.bookJson!.coverImage!,
                                            height: 240.h,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return SizedBox(
                                                height: 240.h,
                                                width: 190.w,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8.r),
                                                  child: initialsAvatar(
                                                      widget.bookJson?.title ??
                                                          "NA"),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                //TODO::  title of book
                                    : SizedBox(
                                        height: 240.h,
                                        width: 190.w,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          child: initialsAvatar(
                                              widget.bookJson?.title ?? "NA"),
                                        ),
                                      ),
                                SizedBox(width: 20.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //TODO :: Title heading
                                      RalewayTextWidget(
                                        fontsize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: ColorUtils.mediumGrayColor,
                                        text: titleText,
                                      ),
                                      //TODO::  book title
                                      RalewayTextWidget(
                                        fontsize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        color: ColorUtils.mediumGrayColor,
                                        text: widget.bookJson?.title ?? 'N/A',
                                      ),

                                      SizedBox(height: 20.h),
                                      //TODO::  author text
                                      RalewayTextWidget(
                                        fontsize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: ColorUtils.mediumGrayColor,
                                        text: authorText,
                                      ),
                                      //TODO:: author name
                                      RalewayTextWidget(
                                        fontsize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        color: ColorUtils.mediumGrayColor,
                                        text: widget.bookJson?.author?.name ??
                                            'N/A',
                                      ),
                                      // Subtitle
                                      SizedBox(height: 20.h),
                                      //TODO::  publisher year heading
                                      RalewayTextWidget(
                                        fontsize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: ColorUtils.mediumGrayColor,
                                        text: publishedYear,
                                      ),
                                      //TODO::  publisher year
                                      RalewayTextWidget(
                                        fontsize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        color: ColorUtils.mediumGrayColor,
                                        text: widget.bookJson?.publishedYear ??
                                            'N/A',
                                      ), SizedBox(height: 20.h),
                                      //TODO::  status
                                      RalewayTextWidget(
                                        fontsize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: ColorUtils.mediumGrayColor,
                                        text: status,
                                      ),
                                      SizedBox(height: 6.h),
                                      //TODO::  book status available or borrow
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(widget.bookJson?.status),
                                              borderRadius: BorderRadius.circular(12.r),
                                            ),
                                            child: RalewayTextWidget(
                                              fontsize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: ColorUtils.whiteColor,
                                              text: widget.bookJson?.status ?? "N/A",
                                            ),
                                          ),

                                          // Visibility(
                                          //     visible:false,
                                          //     child: SizedBox(width: 16.w)), // Spacing between badge and text
                                          // //TODO::  total copies
                                          // Visibility(
                                          //   visible: false,
                                          //   child: RalewayTextWidget(
                                          //     fontsize: 18.sp,
                                          //     fontWeight: FontWeight.w400,
                                          //     color: ColorUtils.mediumGrayColor,
                                          //     text: 'In stock: ${widget.bookJson?.totalCopies ??0}'
                                          //      // text: 'In stock: ${widget.bookJson?.availableCopies ?? 0} / ${widget.bookJson?.totalCopies ?? 0}'
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            //TODO::  about text
                            RalewayTextWidget(
                              fontsize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorUtils.mediumGrayColor,
                              text: aboutText,
                            ),
                            SizedBox(height: 5.h),
                            //TODO::  description
                            RalewayTextWidget(
                              fontsize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.mediumGrayColor,
                              text: widget.bookJson?.description ??
                                  'No Summary available.',
                            ),
                            SizedBox(height: 180.h),
                            //TODO::  based on permission show elevated button to assign
                            Visibility(
                              visible: canAddBook,
                              child: SizedBox(
                                width: double.infinity,
                                child: CustomElevatedButton(
                                  buttonText: bookAssignText,
                                  onPressed: () {
                                    showAssignBookDialog(context, ref);
                                  },
                                  borderRadius: 8.r,
                                  fontSize: 28.sp,
                                  backgroundColor: ColorUtils.yellowColor,
                                  borderColor: ColorUtils.yellowColor,
                                  textColor: ColorUtils.whiteColor,
                                  height: 80.h,
                                ),
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
          ],
        ),
      ),
    );
  }
  //TODO::  dialog show of user assign books by owner
  void showAssignBookDialog(
      BuildContext context,
      WidgetRef ref,
      ) {
    final TextEditingController notesController = TextEditingController();
    final TextEditingController issueDateController = TextEditingController();
    final TextEditingController dueDateController = TextEditingController();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    DateTime issueDate = DateTime.now();
    DateTime? dueDate;

    issueDateController.text =
    "${issueDate.day}-${issueDate.month}-${issueDate.year}";

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: ColorUtils.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              //TODO::  title of assign books
              title: RalewayTextWidget(
                fontsize: 18.sp,
                fontWeight: FontWeight.w400,
                color: ColorUtils.blackColor,
                text: assignBook,
              ),

              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TODO :: USER
                      RalewayTextWidget(
                        fontsize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.blackColor,
                        text: selectUser,
                      ),
                      SizedBox(height: 5.h,),
                      //TODO :: User assign dropdown
                      CustomDropdownSearch(
                        showSearchBox: false,
                        items:
                        ref.watch(userAssignedProvider),
                        selectedItem:
                        ref.watch(selectedTypeOfUserAssigned),
                        onChanged: (selectedItem) {
                          ref
                              .read(selectedTypeOfUserAssigned.notifier)
                              .state = selectedItem!;
                        },
                        itemAsString: (typeOfIndustry) {
                          if (typeOfIndustry == null) {
                            return "Not selected";
                          } else {
                            return typeOfIndustry.borrowerName ??
                                "--select--";
                          }
                        },
                        onValidate: (value) {
                          // Check if value is null before trying to access its properties
                          if (value == null) {
                            return selectTypeOfUser;
                          } else if (value.borrowerName == null ||
                              value.borrowerName!
                                  .toLowerCase()
                                  .contains("please")) {
                            return selectTypeOfUser;
                          } else {
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 5.h,),

                      //TODO :: ISSUE DATE
                      RalewayTextWidget(
                        text: issueDateText,
                        fontsize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.blackColor,
                      ),
                      SizedBox(height: 5.h,),
                      //TODO::  issue date text field
                      CustomTextFieldSplash(
                        labelText: dateHint,
                        controller: issueDateController,
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
                            setState(() {
                              issueDate = pickedDate;
                              issueDateController.text =
                              "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select issue date";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 5.h,),

                      //TODO ::DUE DATE
                      RalewayTextWidget(
                        text: returnDateText,
                        fontsize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.blackColor,
                      ),
                      SizedBox(height: 5.h,),
                      //TODO:: due date text field
                      CustomTextFieldSplash(
                        labelText: dateHint,
                        controller: dueDateController,
                        isDateField: true,
                        readOnly: true,
                        keyboardType: TextInputType.datetime,
                        hintColor: ColorUtils.lightBlackTextColor,
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate:
                            DateTime.now().add(const Duration(days: 1)),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              dueDate = pickedDate;
                              dueDateController.text =
                              "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select due date";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 5.h,),

                      //TODO :: NOTES
                      RalewayTextWidget(
                        text: notesHeading,
                        fontsize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorUtils.blackColor,
                      ),
                      SizedBox(height: 5.h,),
                      //TODO:: notes text field
                      CustomTextFieldSplash(
                        labelText: hintNotes,
                        controller: notesController,
                        keyboardType: TextInputType.text,
                        hintColor: ColorUtils.lightBlackTextColor,
                      ),

                      SizedBox(height: 20.h),

                      //TODO :: Cancel BUTTON
                      Row(
                        children: [
                          Expanded(
                            child: CustomElevatedButton(
                              buttonText: cancel,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              borderRadius: 8.r,
                              fontSize: 28.sp,
                              backgroundColor: ColorUtils.lightBlackTextColor,
                              borderColor: ColorUtils.lightBlackTextColor,
                              textColor: ColorUtils.whiteColor,
                              height: 55.h,
                            ),
                          ),

                          SizedBox(width: 10.w),
                          //TODO:: assign button
                          Expanded(
                            child: CustomElevatedButton(
                              buttonText: assignBookText,
                              onPressed: () async {
                                if (!formKey.currentState!.validate()) return;

                                if (!await Utils.isInternetAvailable()) {
                                  Utils.showToast(networkErrorMessage);
                                  return;
                                }

                                final selectedUser =
                                ref.read(selectedTypeOfUserAssigned);
                                ref
                                    .read(apiDetailBookNotifierProvider.notifier)
                                    .borrowBook(
                                  bookId: widget.bookJson!.id!,
                                  userId: selectedUser.borrowerId!,
                                  issueDate: issueDate,
                                  dueDate: dueDate!,
                                  notes: notesController.text,
                                );

                                Navigator.pop(context); // close after success trigger
                              },
                              borderRadius: 8.r,
                              fontSize: 28.sp,
                              backgroundColor: ColorUtils.yellowColor,
                              borderColor: ColorUtils.yellowColor,
                              textColor: ColorUtils.whiteColor,
                              height: 55.h,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
//TODO::  showing 2 Alphabets of title
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
//TODO::  color update bases on th status
Color _getStatusColor(String? status) {
  switch (status?.toLowerCase()) {

    case "available":
      return ColorUtils.greenColor;

    case "borrowed":
      return  ColorUtils.lightYellowColor;

    default:
      return ColorUtils.greyColor;
  }
}
//TODO::  initials
Widget initialsAvatar(String title) {
  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: ColorUtils.lightYellow,
      borderRadius: BorderRadius.circular(0),
    ),
    child: RalewayTextWidget(
      fontsize: 40.sp,
      fontWeight: FontWeight.w800,
      color: ColorUtils.blackColor,
      text: getInitials(title),
    ),
  );
}
