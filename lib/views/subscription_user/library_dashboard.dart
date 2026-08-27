import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/models/response/login_response/Data.dart';
import 'package:flutter_base/models/response/login_response/LibraryLogin.dart';
import 'package:flutter_base/models/response/sync/SyncResponse.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/providers/api_dashboard_notifier.dart' as dashboard;
import 'package:flutter_base/providers/api_library_dashboard_notifier.dart';
import 'package:flutter_base/route/routes.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_base/utils/image_assets.dart';
import 'package:flutter_base/utils/strings.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/views/detail_screen/detail_book_screen.dart';
import 'package:flutter_base/views/qr_scanner_screen/qr_scanner_screen.dart';
import 'package:flutter_base/views/subscription/Subscription.dart';
import 'package:flutter_base/widgets/dialog_widget/dialog_widget.dart';
import 'package:flutter_base/widgets/loading_widget.dart';
import 'package:flutter_base/widgets/raleway_text_widget.dart';
import 'package:flutter_base/widgets/text_field_widget/custom_text_field_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/response/get_library_response/Library.dart';
import '../../utils/api_state_model.dart';
import '../../widgets/custom_card_value_container.dart';
import '../../widgets/custom_drop_down_search.dart';
import '../../widgets/drawer_item.dart';
import '../dashboard/dashboard.dart';
import '../favorite_books/favorite_book_screen.dart';
import '../qr_scanner_screen/qr_scanner_detail.dart';

class LibraryDashboardScreen extends ConsumerStatefulWidget {
  const LibraryDashboardScreen({super.key});

  @override
  LibraryDashboardScreenState createState() => LibraryDashboardScreenState();
}

class LibraryDashboardScreenState extends ConsumerState<LibraryDashboardScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // :: TODO sync data when widgets tree loaded
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //TODO :: fetch libraries or package or platform plans
      if (await Utils.isInternetAvailable()) {
        refreshField();
        await ref.read(apiLibraryDashboardNotifierProvider.notifier).fetchLibraries();
        final List<Library> allApiLibraries = ref.read(librariesProvider);
        final List<LibraryLogin> savedLibraries = await Utils.getLibrariesList();
        List<Library> finalLibraryList;
        if (savedLibraries.isEmpty) {
          finalLibraryList = allApiLibraries;
        } else {
          final savedIds = savedLibraries.map((e) => e.id).toSet();
          finalLibraryList = allApiLibraries
              .where((lib) => !savedIds.contains(lib.id))
              .toList();
        }
        ref.read(librariesProvider.notifier).state = finalLibraryList;
        if (finalLibraryList.isNotEmpty) {
          final Data? userData = await Utils.getUserData();
          String? role = userData?.user?.role;
          Library? selectedLibrary;

          if (role != null) {
            final LibraryLogin? savedLibrary = await Utils.getSelectedLibraryForRole(role);
            if (savedLibrary != null) {
              selectedLibrary = Library(id: savedLibrary.id, name: savedLibrary.name);
            }
          }
          selectedLibrary ??= finalLibraryList.first;
          ref.read(selectedLibraryProvider.notifier).state = selectedLibrary;
        }

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
    ref.listen<ApiStatesModel>(apiLibraryDashboardNotifierProvider,
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
                        msg: _response.message!,
                        toastLength: Toast.LENGTH_SHORT);
                    // }
                  } else {

                  }
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
    final libraries = ref.watch(librariesProvider);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        ref.invalidate(librariesProvider);
        ref.invalidate(selectedLibraryProvider);
        ref.invalidate(apiLibraryDashboardNotifierProvider);
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorUtils.whiteColor,
        body: Stack(
          children: [
            //TODO :: dashboard background image
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
                      padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30.h,),
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
                              //TODO ::library text heading
                              RalewayTextWidget(
                                fontsize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.whiteColor,
                                text: libraryText,
                              ),
                              const Spacer(),
                            ],
                          ),
                          SizedBox(height: 70.h,),
                          //TODO :: search text field
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
                                      prefixIconWidget: SvgPicture.asset(searchIcon,
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
                      padding:  EdgeInsets.only(left: 15.0.w,right: 15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.h,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //TODO :: library text heading
                              RalewayTextWidget(
                                fontsize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.mediumGrayColor,
                                text: libraryText,
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h,),
                          //TODO :: data empty show not data available
                          Expanded(
                            child: libraries.isEmpty
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
                            //TODO :: list of libraries that user assign
                                : GridView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.h),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.w,
                                mainAxisSpacing: 10.h,
                                childAspectRatio: 0.70,
                              ),
                              itemCount: libraries.length,
                              itemBuilder: (context, index) {
                                final library = libraries[index];

                                return InkWell(
                                  onTap: () {
                                    ref.read(selectedLibraryProvider.notifier).state = library;

                                    Navigator.pushNamed(
                                      context,
                                      Routes.SUBSCRIPTION_SCREEN,
                                      arguments: library,
                                    );
                                  },
                                  //TODO :: library name location
                                  child: CustomCardValueContainer(
                                    icon: initialsAvatar(library.name ?? ""),
                                    title: library.name ?? "N/A",
                                    subtitle: library.location ?? "No location",
                                    subtitleMaxLines: 1,
                                    backgroundColor: ColorUtils.whiteColor,
                                    showSubscribeButton: true,
                                    onTap: () {
                                      ref.read(selectedLibraryProvider.notifier).state = library;
                                      Navigator.pushNamed(
                                        context,
                                        Routes.SUBSCRIPTION_SCREEN,
                                        arguments: library,
                                      );
                                    },
                                  ),

                                );
                              },

                            ),
                          ),

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
  //TODO :: get title
  Widget initialsAvatar(String title) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color:ColorUtils.lightYellow,
        borderRadius: BorderRadius.circular(0),
      ),
      child: RalewayTextWidget(
        fontsize: 34.sp,
        fontWeight: FontWeight.w800,
        color: ColorUtils.blackColor,
        text: getInitials(title),
      ),
    );

  }
  //TODO :: refresh field
  void refreshField() {
    // await ref.refresh(apiDashboardNotifierProvider.notifier).fetchBooksByLibrary(selectedLibrary!.id!);
    ref.refresh(selectedLibraryProvider.notifier).state;
    ref.refresh(booksListProvider.notifier).state;
  }
}