import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../providers/api_assigned_books_notifier.dart';
import '../../utils/api_state_model.dart';
import '../../widgets/button_widget/success_dialog.dart';

class BookAssignedScreen extends ConsumerStatefulWidget {
  const BookAssignedScreen({super.key});

  @override
  BookAssignedScreenState createState() => BookAssignedScreenState();
}

class BookAssignedScreenState extends ConsumerState<BookAssignedScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final searchController = TextEditingController();
  String? role;
  bool canAddBook = false;

  @override
  void initState() {
    super.initState();
    // :: TODO sync data when widgets tree loaded
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      refreshField();
      //TODO :: permission bases data show
      final userData = await Utils.getUserData();
      canAddBook = Utils.canAddBookFromUserData(userData);
      if (await Utils.isInternetAvailable()) {
        refreshField();
        //TODO :: api of fetch all list of borrow books
        await ref
            .read(apiAssignedBooksNotifierProvider.notifier)
            .fetchBorrowBooks();
      } else {
        Utils.showToast(networkErrorMessage);
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
    ref.listen<ApiStatesModel>(apiAssignedBooksNotifierProvider,
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

            final isSuccess =
                response.status == "success";
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
              refreshField();
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
        LoadingWidget(),
      ],
    );
  }

  Widget _mainLayout() {
    final bookBorrowed = ref.watch(bookBorrowedProvider);

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
            //TODO:: image of background
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
                              //TODO :: book assigned text
                              RalewayTextWidget(
                                fontsize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.whiteColor,
                                text: bookBorrowText,
                              ),
                              Spacer(),
                            ],
                          ),
                          SizedBox(
                            height: 70.h,
                          ),
                          //TODO :: book searching field
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //TODO :: book borrow text
                              RalewayTextWidget(
                                fontsize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.mediumGrayColor,
                                text: bookBorrowText,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          //TODO :: showing book menu and no data available when list empty
                          Expanded(
                            child: bookBorrowed.isEmpty
                                ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.menu_book, size: 60.h, color: ColorUtils.greenTextColor),
                                  SizedBox(height: 10.h),
                                  RalewayTextWidget(
                                    fontsize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: ColorUtils.lightBlackTextColor,
                                    text: noDataAvailable,
                                  ),
                                ],
                              ),
                            )
                            //TODO :: list of borrow books shwoing
                                : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                              itemCount: bookBorrowed.length,
                              itemBuilder: (context, index) {
                                final bookBorrow = bookBorrowed[index];
                                return Center(
                                  child: Card(
                                    color: ColorUtils.whiteColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: ColorUtils.greyColor, width: 1.w),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    margin: EdgeInsets.only(bottom: 12.h),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.w),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              //TODO:: Image Component
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(6.r),
                                                child: Container(
                                                  height: 86.h,
                                                  width: 55.w,
                                                  color: ColorUtils.lightGrey,
                                                  child: (bookBorrow.coverImage != null &&
                                                      bookBorrow.coverImage!.isNotEmpty)
                                                      ? Image.network(
                                                    bookBorrow.coverImage!,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return initialsAvatar(bookBorrow.title ?? "NA");
                                                    },
                                                  )
                                                      : initialsAvatar(bookBorrow.title ?? "NA"),
                                                ),
                                              ),
                                              SizedBox(width: 12.w),

                                              Expanded(
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          //TODO :: title of book
                                                          RalewayTextWidget(
                                                            fontsize: 15.sp,
                                                            fontWeight:
                                                            FontWeight.w700,
                                                            color:
                                                            ColorUtils.blackColor,
                                                            maxLines: 2,
                                                            text: bookBorrow.title ??
                                                                "N/A",
                                                          ),
                                                          SizedBox(height: 4.h),
                                                          //TODO :: library name where book borrow
                                                          RalewayTextWidget(
                                                            fontsize: 12.sp,
                                                            fontWeight: FontWeight.w400,
                                                            color: ColorUtils.mediumGrayColor,
                                                            maxLines: 3,
                                                            text:
                                                            "borrow: ${bookBorrow.library?.name ?? 'N/A'}",
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.w),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          //TODO :: assigned date text heading
                                                          RalewayTextWidget(
                                                            fontsize: 13.sp,
                                                            fontWeight:
                                                            FontWeight.w700,
                                                            color:
                                                            ColorUtils.blackColor,
                                                            text:  assignedDateText,
                                                          ),
                                                          SizedBox(height: 4.h),
                                                          //TODO :: issue date showing
                                                          RalewayTextWidget(
                                                            fontsize: 13.sp,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                            color: ColorUtils
                                                                .mediumGrayColor,
                                                            text: Utils.getDate(bookBorrow.activeLoan?.issuedAt??
                                                                "N/A",
                                                            )),

                                                          SizedBox(height: 4.h),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(width: 10.w),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          //TODO :: due date text heading
                                                          RalewayTextWidget(
                                                            fontsize: 13.sp,
                                                            fontWeight:
                                                            FontWeight.w700,
                                                            color:
                                                            ColorUtils.blackColor,
                                                            text:  dueDateText,
                                                          ),
                                                          SizedBox(height: 4.h),
                                                          //TODO :: showing due date
                                                          RalewayTextWidget(
                                                            fontsize: 13.sp,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                            color: ColorUtils
                                                                .mediumGrayColor,
                                                            text: Utils.getDate(bookBorrow.activeLoan?.dueAt??
                                                                "N/A",
                                                            )),

                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //TODO :: only permission bases showing
                                              if (canAddBook) Expanded(
                                                child: Row(
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {},
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12.w,
                                                            vertical: 10.h),
                                                        minimumSize:
                                                        Size(50.w, 30.h),
                                                        shape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(12.r),
                                                        ),
                                                        backgroundColor:
                                                        ColorUtils
                                                            .lightGreenColor,
                                                      ),
                                                      //TODO :: status of showing
                                                      child: RalewayTextWidget(
                                                        fontsize: 13.sp,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        color:
                                                        ColorUtils.whiteColor,
                                                        text: bookBorrow.status ??
                                                            "N/A",
                                                      ),
                                                    ),
                                                    SizedBox(width: 6.w),
                                                    //TODO :: api call of book return
                                                    Visibility(
                                                      visible :false,
                                                      child: ElevatedButton.icon(
                                                        onPressed: () async {
                                                          if (await Utils
                                                              .isInternetAvailable()) {
                                                            ref
                                                                .read(
                                                                apiAssignedBooksNotifierProvider
                                                                    .notifier)
                                                                .bookReturn(
                                                                bookBorrow.id!);
                                                          } else {
                                                            Utils.showToast(
                                                                networkErrorMessage);
                                                          }
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 12.w,
                                                              vertical: 10.h),
                                                          minimumSize:
                                                          Size(50.w, 30.h),
                                                          shape:
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(12.r),
                                                          ),
                                                          backgroundColor:
                                                          ColorUtils
                                                              .blueColor,
                                                        ),
                                                        icon: Icon(
                                                          Icons.refresh,
                                                          size: 18.h,
                                                          color:
                                                          ColorUtils.whiteColor,
                                                        ),
                                                        label: RalewayTextWidget(
                                                          fontsize: 13.sp,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color:
                                                          ColorUtils.whiteColor,
                                                          text: returnText,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                              //TODO :: else case showing in use when borrow books
                                              else
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 12.w,
                                                        vertical: 10.h),
                                                    minimumSize:
                                                    Size(50.w, 30.h),
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(12.r),
                                                    ),
                                                    backgroundColor:
                                                    ColorUtils
                                                        .greenColor,
                                                  ),
                                                  child: RalewayTextWidget(
                                                    fontsize: 13.sp,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color:
                                                    ColorUtils.whiteColor,
                                                    text: inUseText,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
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
  //TODO :: when no image come showing first two letter of title
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
 //TODO :: get Initials showing
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
  //TODO:: refresh field
  void refreshField() {
    // await ref.refresh(apiDashboardNotifierProvider.notifier).fetchBooksByLibrary(selectedLibrary!.id!);
    ref.refresh(bookBorrowedProvider.notifier).state;
  }
}
