import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/models/response/sync/SyncResponse.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/providers/api_dashboard_notifier.dart';
import 'package:flutter_base/route/routes.dart';
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
import 'package:url_launcher/url_launcher.dart';
import '../../models/response/book/GoogleBook.dart';
import '../../utils/api_state_model.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/drawer_item.dart';

class QRScannerDetailScreen extends ConsumerStatefulWidget {
  final GoogleBook? bookJson;
  const QRScannerDetailScreen( {super.key,  this.bookJson});

  @override
  QRScannerDetailScreenState createState() => QRScannerDetailScreenState();
}

class QRScannerDetailScreenState extends ConsumerState<QRScannerDetailScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final searchController = TextEditingController();
  final bookTitleController = TextEditingController();
  final bookEditionController = TextEditingController();
  final authorController = TextEditingController();
  final publisherNameController = TextEditingController();
  final publisherDateController = TextEditingController();
  final isbController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // :: TODO sync data when widgets tree loaded
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // getSyncData();
    });
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // :: TODO listen api responses
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

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorUtils.whiteColor,
        key: _key,
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
                width: double.infinity,
                height: 260.h,
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
                      padding:
                      EdgeInsets.symmetric(horizontal: 34.w, vertical: 34.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //TODO :: back arrow icon
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
                              //TODO ::book detail heading
                              RalewayTextWidget(
                                fontsize: 24.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.whiteColor,
                                text: bookDetailText,
                              ),
                              const Spacer(),
                              //TODO :: icon of share to share the book
                              SvgPicture.asset(
                                shareIcon,
                                height: 35.h,
                              ),
                              SizedBox(width: 10.w),
                              //TODO :: icon of  save to add favorite books
                              SvgPicture.asset(
                                saveIcon,
                                height: 35.h,
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                  //TODO :: showing book detail
                  Expanded(
                    child: Padding(
                      padding:  EdgeInsets.only(left: 20.0.w,right: 20.w),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //TODO :: book image available showing that or not available then showing title
                                (widget.bookJson?.thumbnail != null &&
                                    widget.bookJson!.thumbnail!.isNotEmpty)
                                    ? Image.network(
                                  widget.bookJson!.thumbnail!,
                                  height: 240.h,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return SizedBox(
                                      height: 240.h,
                                      width: 190.w,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.r),
                                        child: initialsAvatar(widget.bookJson?.title ?? "NA"),
                                      ),
                                    );
                                  },
                                )
                                    : SizedBox(
                                  height: 240.h,
                                  width: 190.w,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: initialsAvatar(widget.bookJson?.title ?? "NA"),
                                  ),
                                ),

                                SizedBox(width: 20.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //TODO :: Title heading
                                      RalewayTextWidget(
                                        fontsize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: ColorUtils.mediumGrayColor,
                                        text: titleText,
                                      ),
                                      //TODO :: title showing
                                      RalewayTextWidget(
                                        fontsize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        color: ColorUtils.mediumGrayColor,
                                        text: widget.bookJson?.title ?? 'N/A',
                                      ),

                                      SizedBox(height: 20.h),
                                      //TODO ::heading of author/publisher
                                      RalewayTextWidget(
                                        fontsize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: ColorUtils.mediumGrayColor,
                                        text: authorText,
                                      ),
                                      //TODO :: publisher showing
                                      RalewayTextWidget(
                                        fontsize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        color: ColorUtils.mediumGrayColor,
                                        text: widget.bookJson?.publisher?? 'N/A',
                                      ),
                                      // Subtitle
                                      SizedBox(height: 20.h),
                                      //TODO :: publisher date heading
                                      RalewayTextWidget(
                                        fontsize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        color: ColorUtils.mediumGrayColor,
                                        text: publishedYear,
                                      ),
                                      //TODO :: publisher date show
                                      RalewayTextWidget(
                                        fontsize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        color: ColorUtils.mediumGrayColor,
                                        text: widget.bookJson?.publishedDate ?? 'N/A',
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40.h),
                            //TODO ::about text heading
                            RalewayTextWidget(
                              fontsize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorUtils.mediumGrayColor,
                              text: aboutText,
                            ),
                            SizedBox(height: 20.h),
                            //TODO ::description text
                            RalewayTextWidget(
                              fontsize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorUtils.mediumGrayColor,
                              text: widget.bookJson?.description??'No Summary available.',
                            ),
                            SizedBox(height: 180.h),
                            Row(
                              children: [
                                //TODO :: read online if url available then open online elevated button
                                Expanded(
                                  child: CustomElevatedButton(
                                    buttonText: readOnlineText,
                                      onPressed: () {
                                        final url = widget.bookJson?.previewLink;
                                        if (url != null) {
                                          openUrl(url);
                                      }
                                    },
                                    borderRadius: 99.r,
                                    fontSize: 31.sp,
                                    backgroundColor: ColorUtils.yellowColor,
                                    borderColor: ColorUtils.yellowColor,
                                    textColor: ColorUtils.whiteColor,
                                    height: 104.h,// Text color
                                  ),
                                ),
                                SizedBox(width: 26.w,),
                                // :: TODO download  Button to download the book
                                Expanded(
                                  child: CustomElevatedButton(
                                    buttonText: downloadText,
                                    borderRadius: 99.r,
                                    fontSize: 31.sp,
                                    onPressed: () {
                                      final url = widget.bookJson?.pdfDownloadLink;
                                      if (url != null) {
                                        openUrl(url);
                                      }
                                    },
                                    backgroundColor: ColorUtils.lightGreenColor,
                                    textColor: ColorUtils.whiteColor,
                                    borderColor: ColorUtils.lightGreenColor,
                                    height: 104.h,// Text color
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 30.h),
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
//TODO :: open url when url available then open on that url
Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
//TODO :: initials avatar
Widget initialsAvatar(String title) {
  return Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: ColorUtils.lightYellow,
      borderRadius: BorderRadius.circular(0),
    ),
    child:RalewayTextWidget(
      fontsize: 40.sp,
      fontWeight: FontWeight.w800,
      color: ColorUtils.blackColor,
      text: getInitials(title),
    ),
  );
}