import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/models/response/login_response/Data.dart';
import 'package:flutter_base/models/response/login_response/LibraryLogin.dart';
import 'package:flutter_base/models/response/sync/SyncResponse.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/providers/api_dashboard_notifier.dart';
import 'package:flutter_base/route/routes.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_base/utils/image_assets.dart';
import 'package:flutter_base/utils/strings.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/views/book_event/create_event_screen.dart';
import 'package:flutter_base/views/books_assigned/book_user_assigned_screen.dart';
import 'package:flutter_base/views/detail_screen/detail_book_screen.dart';
import 'package:flutter_base/views/qr_scanner_screen/qr_scanner_screen.dart';
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
import '../../widgets/drawer_item.dart';
import '../books_assigned/book_assigned_screen.dart';
import '../favorite_books/favorite_book_screen.dart';
import '../qr_scanner_screen/qr_scanner_detail.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends ConsumerState<DashboardScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final searchController = TextEditingController();
  String? role;
  bool canAddBook = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      refreshField();
      final Data? userData = await Utils.getUserData();
      ref.read(userDataProvider.notifier).state = userData?.user;
      role = userData?.user?.role;
      canAddBook = Utils.canAddBookFromUserData(userData);
      //TODO :: user assigned library list fetch
      if (await Utils.isInternetAvailable()) {
        final List<LibraryLogin> savedLibraries =
            await Utils.getLibrariesList();

        final List<Library> libraryList = savedLibraries
            .map((lib) => Library(id: lib.id, name: lib.name))
            .toList();

        ref.read(librariesProvider.notifier).state = libraryList;

        if (libraryList.isEmpty) return;
        final Data? userData = await Utils.getUserData();
        String? role = userData?.user?.role;
        Library? selectedLibrary;

        if (role != null) {
          final LibraryLogin? savedLibrary =
              await Utils.getSelectedLibraryForRole(role);
          if (savedLibrary != null) {
            selectedLibrary =
                Library(id: savedLibrary.id, name: savedLibrary.name);
          }
        }
        selectedLibrary ??= libraryList.first;

        ref.read(selectedLibraryProvider.notifier).state = selectedLibrary;
        //TODO :: fetch list of books bases on the library
        await ref
            .read(apiDashboardNotifierProvider.notifier)
            .fetchBooksByLibrary(selectedLibrary.id!);
        //TODO :: sync api call
        await ref
            .read(apiDashboardNotifierProvider.notifier)
            .getApiSyncData(selectedLibrary.id!);
      } else {
        Utils.showToast(networkErrorMessage);
      }
    });
  }

//TODO ::
  Future<void> loadFormListData() async {
    final isInternetAvailable = await Utils.isInternetAvailable();
    if (isInternetAvailable) {
      final selectedLibrary = ref.read(selectedLibraryProvider);
      if (selectedLibrary != null) {
        await ref
            .read(apiDashboardNotifierProvider.notifier)
            .getApiSyncData(selectedLibrary.id!);
      }
    } else {
      Fluttertoast.showToast(msg: networkErrorMessage);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ApiStatesModel>(apiDashboardNotifierProvider,
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
    final books = ref.watch(booksListProvider);
    final items = books.map((b) => b.title).toList();
    final subtitle = books.map((b) => b.author!.name).toList();
    final icons = books.map((b) => b.coverImage).toList();
    final userData = ref.read(userDataProvider);
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorUtils.whiteColor,
        key: _key,
        //TODO :: drawer
        drawer: Drawer(
          width: 1.sw - 0.2.sw,
          backgroundColor: ColorUtils.whiteColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 1.sw,
                  height: 280.h,
                  decoration: const BoxDecoration(
                    color: ColorUtils.greenTextColor,
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20.h),
                          //TODO :: back arrow button
                          Padding(
                            padding:  EdgeInsets.only(left: 10.0.w),
                            child: InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Transform.rotate(
                                angle: 3.14,
                                child: SvgPicture.asset(
                                  backArrowIcon,
                                  height: 70.h,
                                  width: 50.w,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 50.h),
                          //TODO :: digital library text
                          Visibility(
                            visible: false,
                            child: RalewayTextWidget(
                              fontsize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorUtils.whiteColor,
                              text: digitalLibraryText,
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.only(left: 18.0.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //TODO :: user name
                                RalewayTextWidget(
                                  fontsize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorUtils.whiteColor,
                                  maxLines: 1,
                                  text: userData?.name ?? "N/A",
                                ),
                                SizedBox(height: 10.h),
                                //TODO :: user email
                                RalewayTextWidget(
                                  fontsize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  maxLines: 1,
                                  color: ColorUtils.whiteColor,
                                  text: userData?.email ?? "N/A",
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),

                //TODO :: sync data
                InkWell(
                  onTap: () {
                    loadFormListData();
                  },
                  child: DrawerItemWidget(
                iconWidget: Image.asset(syncImage),
                    iconSize: 28.h,
                    textSize: 30.sp,
                    onTap: () {
                      loadFormListData();
                    },
                    title: syncText,
                    isSelect: false,
                  ),
                ),
                //TODO :: borrow books based on the permission
                Visibility(
                  visible: !canAddBook,
                  child: DrawerItemWidget(
                    iconWidget: Image.asset(borrowBookImage),
                    iconSize: 35.h,
                    textSize: 30.sp,
                    color: ColorUtils.blackColor,
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const BookAssignedScreen()),
                      );
                    },
                    title: bookBorrowText,
                    isSelect: false,
                  ),
                ),
                //TODO :: book assigned based on the permission
                Visibility(
                  visible: canAddBook,
                  child: DrawerItemWidget(
                    iconWidget: Image.asset(bookAssignImage),
                    iconSize: 36.h,
                    textSize: 30.sp,
                    color: ColorUtils.blackColor,
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const BookUserAssignedScreen()),
                      );
                    },
                    title: bookAssignedText,
                    isSelect: false,
                  ),
                ),
                //TODO :: favorite book bases on the user
                DrawerItemWidget(
                  iconWidget: Image.asset(favoriteBookImage),
                  iconSize: 33.h,
                  textSize: 30.sp,
                  color: ColorUtils.blackColor,
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const FavoriteBooksScreen()),
                    );
                  },
                  title: favoriteText,
                  isSelect: false,
                ),
                //TODO :: permission based event add
                Visibility(
                  visible: canAddBook,
                  child: DrawerItemWidget(
                    iconWidget: Image.asset(addEventImage),
                    iconSize: 32.h,
                    textSize: 30.sp,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CreateEventScreen()),
                      );
                    },
                    title: addNewEventText,
                    isSelect: false,
                  ),
                ),
                //TODO :: event show
                DrawerItemWidget(
                    iconWidget: Image.asset(eventCalendarImage),
                    iconSize: 35.h,
                  textSize: 30.sp,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.BOOK_EVENT,
                    );
                  },
                  title: eventText,
                  isSelect: false,
                ),
                //TODO :: library  show
                // Visibility(
                //   visible: !canAddBook,
                //   child:
                DrawerItemWidget(
                  iconWidget: Image.asset(libraryImage),
                  iconSize: 34.h,
                  textSize: 30.sp,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.LIBRARY_DASHBOARD_SCREEN,
                    );
                  },
                  title: libraryText,
                  isSelect: false,
                  // ),
                ),
                //TODO :: qr scanner scan ibsn
                DrawerItemWidget(
                  iconWidget: Image.asset(qrScannerImage),
                  iconSize: 40.h,
                  textSize: 30.sp,
                  title: qrScannerText,
                  isSelect: false,
                  onTap: () async {
                    Navigator.pop(context);

                    final scannedResult = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const QrScannerScreen()),
                    );

                    if (scannedResult != null) {
                      final book = await ref
                          .read(apiDashboardNotifierProvider.notifier)
                          .fetchBookByIsbn(scannedResult);

                      if (book != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                QRScannerDetailScreen(bookJson: book),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Failed to fetch book")),
                        );
                      }
                    }
                  },
                ),
                //TODO :: logout
                DrawerItemWidget(
                  iconWidget: SvgPicture.asset(logoutIcon),
                  iconSize: 35.h,
                  textSize: 30.sp,
                  color: ColorUtils.firRedColor,
                  onTap: () {
                    Navigator.pop(context);
                    DialogBuilder.showLogoutDialogUser(
                      title: logout,
                      content: confirmation,
                      isCancelable: true,
                      context: context,
                      confirmCallback: () async {
                        await Utils.clearCacheData();
                        await ref
                            .read(apiDashboardNotifierProvider.notifier)
                            .clearDatabase();
                        await Utils.removeIsLoggedIn();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.LOGIN,
                          (route) => false,
                        );
                      },
                      cancelCallback: () {},
                    );
                  },
                  title: logoutText,
                  isSelect: false,
                ),
              ],
            ),
          ),
        ),

        body: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.r),
                bottomRight: Radius.circular(30.r),
              ),
              //TODO :: background image
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
                          Row(
                            children: [
                              //TODO:: drawer icon
                              InkWell(
                                onTap: () {
                                  _key.currentState?.openDrawer();
                                },
                                child: Image.asset(
                                  drawerImage,
                                  height: 30.h,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              //TODO:: text of digital library
                              RalewayTextWidget(
                                fontsize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.whiteColor,
                                text: digitalLibraryText,
                              ),
                              const Spacer(),
                              //TODO:: show dialog to show library and select library
                              InkWell(
                                onTap: () async {
                                  _key.currentState?.closeDrawer();
                                  refreshField();

                                  final libraries = ref.read(librariesProvider);

                                  if (libraries.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("No libraries found!")),
                                    );
                                    return;
                                  }

                                  loadFormListData();

                                  if (libraries.length == 1) {
                                    final selectedLibrary = libraries.first;

                                    await _selectLibraryAndLoad(
                                        selectedLibrary);
                                    return;
                                  }
                                  Library? selectedLibrary =
                                      ref.read(selectedLibraryProvider);

                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: ColorUtils.whiteColor,
                                      surfaceTintColor: ColorUtils.whiteColor,
                                      title: RalewayTextWidget(
                                        fontsize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                        color: ColorUtils.mediumGrayColor,
                                        text: selectLibraryText,
                                      ),
                                      content: StatefulBuilder(
                                        builder: (context, setStateDialog) =>
                                            SingleChildScrollView(
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: ColorUtils.whiteColor,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                border: Border.all(
                                                    color:
                                                        ColorUtils.blackColor)),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 14.w,
                                                vertical: 5.h),
                                            //TODO :: dropdown of library
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<int>(
                                                isExpanded: true,
                                                value: selectedLibrary?.id,
                                                hint: Text(
                                                  selectLibraryText,
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                items: libraries.map((lib) {
                                                  return DropdownMenuItem<int>(
                                                    value: lib.id,
                                                    child: Text(
                                                      lib.name ?? "N/A",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: ColorUtils
                                                            .blackColor,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (int? id) {
                                                  setStateDialog(() {
                                                    selectedLibrary = libraries
                                                        .firstWhere((lib) =>
                                                            lib.id == id);
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      //TODO :: based on the selected library show books
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);

                                            if (selectedLibrary == null) return;

                                            if (await Utils
                                                .isInternetAvailable()) {
                                              final userData =
                                                  await Utils.getUserData();
                                              if (userData?.user?.role !=
                                                  null) {
                                                await Utils
                                                    .saveSelectedLibraryForRole(
                                                  LibraryLogin(
                                                    id: selectedLibrary!.id,
                                                    name: selectedLibrary!.name,
                                                  ),
                                                  userData!.user!.role!,
                                                );
                                              }
                                              ref
                                                  .read(selectedLibraryProvider
                                                      .notifier)
                                                  .state = selectedLibrary;

                                              try {
                                                Utils.printInDebug(
                                                    "Calling API with ID: ${selectedLibrary!.id}");

                                                await ref
                                                    .read(
                                                        apiDashboardNotifierProvider
                                                            .notifier)
                                                    .fetchBooksByLibrary(
                                                        selectedLibrary!.id!);
                                              } catch (e) {
                                                Utils.printInDebug(
                                                    "API ERROR: $e");
                                              }
                                            } else {
                                              Utils.showToast(
                                                  networkErrorMessage);
                                            }
                                          },
                                          //TODO:: ok button
                                          child: RalewayTextWidget(
                                            fontsize: 20.sp,
                                            fontWeight: FontWeight.w700,
                                            color: ColorUtils.gradientColor3,
                                            text: okButtonText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                //TODO:: drawer icon
                                child: Container(

                                  height: 32.h,
                                  width: 38.w,

                                  decoration: BoxDecoration(
                                    color: ColorUtils.whiteColor,
                                    borderRadius: BorderRadius.circular(11.r),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(6.r),
                                    child: Padding(
                                      padding:  EdgeInsets.only(left: 3.0.w,right: 3.w,top: 3.h,bottom: 3.h),
                                      child: Image.asset(
                                        libraryListImage,
                                        fit: BoxFit.contain,
                                      ),

                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 80.h,
                          ),
                          //TODO:: search text field show
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
                      padding: EdgeInsets.only(left: 25.0.w, right: 25.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //TODO:: manage books text  heading
                              RalewayTextWidget(
                                fontsize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.mediumGrayColor,
                                text: manageBooksText,
                              ),
                              //TODO:: based on the permission show add new book button show
                              Visibility(
                                visible: canAddBook,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, Routes.ADD_NEW_BOOK_SCREEN);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 10.h),
                                    minimumSize: Size(50.w, 30.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    backgroundColor: ColorUtils.lightGreenColor,
                                  ),
                                  child: RalewayTextWidget(
                                    fontsize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: ColorUtils.whiteColor,
                                    text: addNewBookText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.h,
                          ),

                          //TODO:: no data available when no library selected or assign
                          Expanded(
                            child: items.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.menu_book,
                                            size: 60.h,
                                            color: ColorUtils.greenTextColor),
                                        SizedBox(height: 10.h),
                                        //TODO:: no book available text
                                        RalewayTextWidget(
                                          fontsize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: ColorUtils.lightBlackTextColor,
                                          text: noBookAvailable,
                                        ),
                                      ],
                                    ),
                                  )
                                //TODO:: showing list of books based on the selected library
                                : GridView.builder(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0.w, vertical: 0.h),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 25.w,
                                      mainAxisSpacing: 15.h,
                                      childAspectRatio: 0.60,
                                    ),
                                    itemCount: items.length,
                                    itemBuilder: (context, index) {
                                      final bookObject = books[index];
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => DetailBookScreen(
                                                  bookJson: books[index]),
                                            ),
                                          );
                                        },
                                        child: CustomCardValueContainer(
                                          icon: (icons[index] != null &&
                                                  icons[index]!.isNotEmpty)
                                              ? Image.network(
                                                  icons[index]!,
                                                  // fit: BoxFit.fill,
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return initialsAvatar(
                                                        items[index] ?? "N/A");
                                                  },
                                                )
                                              : initialsAvatar(
                                                  items[index] ?? "N/A"),
                                          title: items[index] ?? "N/A"!,
                                          subtitle: subtitle[index],
                                          subtitleMaxLines: 2,
                                          backgroundColor:
                                              ColorUtils.whiteColor,
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              Routes.DETAIL_SCREEN,
                                              arguments: bookObject,
                                            );
                                          },
                                          showSubscribeButton: false,
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

  //TODO:: user select library then base on the selected library api call
  Future<void> _selectLibraryAndLoad(Library selectedLibrary) async {
    if (!await Utils.isInternetAvailable()) {
      Utils.showToast(networkErrorMessage);
      return;
    }

    final userData = await Utils.getUserData();

    if (userData?.user?.role != null) {
      await Utils.saveSelectedLibraryForRole(
        LibraryLogin(
          id: selectedLibrary.id,
          name: selectedLibrary.name,
        ),
        userData!.user!.role!,
      );
    }

    ref.read(selectedLibraryProvider.notifier).state = selectedLibrary;

    try {
      Utils.printInDebug(
        "Calling API with ID: ${selectedLibrary.id}",
      );

      await ref
          .read(apiDashboardNotifierProvider.notifier)
          .fetchBooksByLibrary(selectedLibrary.id!);
    } catch (e) {
      Utils.printInDebug("API ERROR: $e");
    }
  }

  //TODO:: get 2 alphabets of title
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

  //TODO:: initials
  Widget initialsAvatar(String title) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorUtils.lightYellow,
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

//TODO:: refresh fields
  void refreshField() {
    // await ref.refresh(apiDashboardNotifierProvider.notifier).fetchBooksByLibrary(selectedLibrary!.id!);
    ref.refresh(selectedLibraryProvider.notifier).state;
    ref.refresh(booksListProvider.notifier).state;
  }
}
