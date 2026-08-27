import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/models/response/get_library_response/Library.dart';
import 'package:flutter_base/models/response/sync/SyncResponse.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/providers/api_subscription_notifier.dart';
import 'package:flutter_base/route/routes.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_base/utils/strings.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_base/widgets/dialog_widget/dialog_widget.dart';
import 'package:flutter_base/widgets/loading_widget.dart';
import 'package:flutter_base/widgets/raleway_text_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../providers/api_dashboard_notifier.dart';
import '../../utils/api_state_model.dart';
import '../../models/response/login_response/PlatformPackage.dart';
import '../../utils/image_assets.dart';
import '../../widgets/drawer_item.dart';
import '../../widgets/text_field_widget/custom_text_field_splash.dart';
import '../dashboard/dashboard.dart';
import '../favorite_books/favorite_book_screen.dart';
import '../qr_scanner_screen/qr_scanner_detail.dart';
import '../qr_scanner_screen/qr_scanner_screen.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  final Library? libraryJson;

  const SubscriptionScreen(this.libraryJson, {super.key});

  @override
  SubscriptionScreenState createState() => SubscriptionScreenState();
}

class SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final searchController = TextEditingController();
  final bookTitleController = TextEditingController();
  final bookEditionController = TextEditingController();
  final authorController = TextEditingController();
  final publisherNameController = TextEditingController();
  final publisherDateController = TextEditingController();
  final isbController = TextEditingController();
  bool isYearly = false;
  PlatformPackage? selectedPackage;
  @override
  void initState() {
    super.initState();
    // :: TODO sync data when widgets tree loaded
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (await Utils.isInternetAvailable()) {
        final libraryId = widget.libraryJson?.id;

        if (libraryId != null) {
          await ref
              .read(apiSubscriptionNotifierProvider.notifier)
              .getSubscriptionByLibrary(libraryId);

          //TODO:: Get packages from provider

          final packages =
          ref.read(typeOfPlatformPackageListStateProvider);

          if (packages.isNotEmpty && mounted) {
            setState(() {
              selectedPackage = packages.first;
            });
          }
        } else {
          Utils.showToast(networkErrorMessage);
        }
      }
    });
  }
  //TODO :: load all data
  void getDropDownsData() async {
    await ref
        .read(apiSubscriptionNotifierProvider.notifier)
        .getAllPlatformPackage();

    final packages = ref.read(typeOfPlatformPackageListStateProvider);

    if (packages.isNotEmpty) {
      setState(() {
        selectedPackage = packages.first;
      });

    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // :: TODO listen api responses
    ref.listen<ApiStatesModel>(apiSubscriptionNotifierProvider,
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
            key: _key,
            body: Stack(children: [
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
                child: Column(children: [
                  SizedBox(
                    height: 0.23.sh,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            //TODO :: back arrow
                            children: [
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: SvgPicture.asset(
                                  backArrow,
                                  height: 35.h,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              //TODO ::package text
                              RalewayTextWidget(
                                fontsize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.whiteColor,
                                text: packagesText,
                              ),
                              const Spacer(),
                            ],
                          ),
                          SizedBox(
                            height: 80.h,
                          ),
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
                                  //TODO :: filter icon
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //TODO :: pick package heading text
                        Center(
                          child: RalewayTextWidget(
                            text: pickTheRight,
                            fontsize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorUtils.blackColor,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        //TODO:: Row of buttons packages
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: ref
                                .watch(typeOfPlatformPackageListStateProvider)
                                .map((pkg) {
                              final isSelected = selectedPackage?.id == pkg.id;
                              return Padding(
                                padding: EdgeInsets.only(right: 12.w),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedPackage = null;
                                      } else {
                                        selectedPackage = pkg;
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isSelected
                                        ? ColorUtils.lightGreenColor
                                        : ColorUtils.mediumGrayColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 12.h),
                                  ),
                                  child: Text(
                                    pkg.name ?? "N/A",
                                    style: TextStyle(
                                      color: ColorUtils.whiteColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        //TODO :: select package navigate to detail screen
                        SizedBox(height: 10.h),
                        if (selectedPackage != null)
                          GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.SUBSCRIPTION_DETAIL_SCREEN,
                                  arguments: {
                                    'library': widget.libraryJson,
                                    'package': selectedPackage,
                                    // previously selected package
                                  },
                                );
                              },
                              child: packageCard(selectedPackage!)),
                      ],
                    ),
                  ),
                ]),
              ),
            ])));
  }
  //TODO :: package card for showing package
  Widget packageCard(PlatformPackage pkg) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorUtils.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorUtils.textFieldBorderColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top header with name, duration & price
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: ColorUtils.greenTextColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //TODO ::name of the package
                        RalewayTextWidget(
                          fontsize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorUtils.whiteColor,
                          text: "${pkg.name ?? "N/A"} Package",
                        ),
                        SizedBox(height: 4.h),
                        //TODO ::duration of package
                        RalewayTextWidget(
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorUtils.whiteColor,
                          text:
                          "${pkg.durationValue ?? ""} ${pkg.durationType ?? "Months"}",
                        ),
                      ],
                    ),

                    //TODO :: Price of package
                    RalewayTextWidget(
                      fontsize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorUtils.whiteColor,
                      text: "${pkg.price ?? "0"}",
                    ),
                  ],
                ),
              ],
            ),
          ),
          //TODO:: Features label
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: RalewayTextWidget(
              fontsize: 22.sp,
              fontWeight: FontWeight.w600,
              color: ColorUtils.blackColor,
              text: featuresText,
            ),
          ),

          //TODO:: Features list
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: (pkg.features ?? []).map((feature) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: ColorUtils.blueColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: RalewayTextWidget(
                          fontsize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorUtils.blackColor,
                          text: feature,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}