import 'package:flutter/material.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/providers/api_add_new_book_notifier.dart';
import 'package:flutter_base/providers/api_create_event_notifier.dart';
import 'package:flutter_base/providers/api_forgot_password_notifier.dart';
import 'package:flutter_base/providers/api_subscription_detail_notifier.dart';
import 'package:flutter_base/providers/api_subscription_notifier.dart';
import 'package:flutter_base/providers/api_dashboard_notifier.dart';
import 'package:flutter_base/providers/api_events_notifier.dart';
import 'package:flutter_base/providers/api_library_dashboard_notifier.dart';
import 'package:flutter_base/widgets/poppins_text_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../providers/api_auth_notifier.dart';
import '../../utils/colors.dart';
import '../../utils/strings.dart';
import '../providers/api_assigned_books_notifier.dart';
import '../providers/api_detail_book_notifier.dart';
import '../providers/api_events_register_notifier.dart';
import '../providers/api_register_notifier.dart';
import '../providers/api_splash_notifier.dart';
import '../providers/api_user_assigned_books_notifier.dart';

class LoadingWidget extends ConsumerStatefulWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  LoadingWidgetState createState() => LoadingWidgetState();
}

class LoadingWidgetState extends ConsumerState<LoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
  }

  @override
  Widget build(BuildContext context) {
    final apiNotifier = ref.watch(apiAuthNotifierProvider);
    final apiDashboardNotifier = ref.watch(apiDashboardNotifierProvider);
    final apiEventNotifier = ref.watch(apiEventsNotifierProvider);
    final apiLibraryDashboardNotifier = ref.watch(apiLibraryDashboardNotifierProvider);
    final apiSubscriptionDetail = ref.watch(apiSubscriptionDetailNotifierProvider);
    final apiSubscription = ref.watch(apiSubscriptionNotifierProvider);
    final apiAddNewBook = ref.watch(apiAddNewBookNotifierProvider);
    final apiBookDetail = ref.watch(apiDetailBookNotifierProvider);
    final apiRegister = ref.watch(apiRegisterNotifierProvider);
    final apiSplash = ref.watch(apiSplashNotifierProvider);
    final apiUserAssign = ref.watch(apiUserAssignedBooksNotifierProvider);
    final apiBorrowedBook = ref.watch(apiAssignedBooksNotifierProvider);
    final apiEventRegister = ref.watch(apiEventRegisterNotifierProvider);
    final apiCreateEvent = ref.watch(apiCreateEventNotifierProvider);
    final apiForgotPassword = ref.watch(apiForgotPasswordNotifierProvider);


    return Visibility(
      visible: apiNotifier.states == States.LOADING ||
          apiDashboardNotifier.states == States.LOADING ||
          apiLibraryDashboardNotifier.states == States.LOADING ||
          apiSubscriptionDetail.states == States.LOADING ||
          apiSubscription.states == States.LOADING ||
          apiAddNewBook.states == States.LOADING ||
          apiUserAssign.states == States.LOADING ||
          apiBookDetail.states == States.LOADING ||
          apiBorrowedBook.states == States.LOADING ||
          apiRegister.states == States.LOADING ||
          apiSplash.states == States.LOADING ||
          apiEventRegister.states == States.LOADING ||
          apiCreateEvent.states == States.LOADING ||
          apiForgotPassword.states == States.LOADING ||
          apiEventNotifier.states == States.LOADING,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: ColorUtils.whiteOpacityColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Card(
                elevation: 10,
                color: ColorUtils.whiteColor,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Column(children: [
                    SpinKitCircle(
                      color: ColorUtils.primaryColor,
                      size: 60.0.h,
                      controller: animationController,
                    ),
                    SizedBox(height: 5.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                      child: Material(
                        color: Colors.transparent,
                        child: PoppinsTextWidget(
                          text: loading,
                          fontsize: 20.sp,
                          fontWeight: FontWeight.normal,
                          color: ColorUtils.blackColor,
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  dispose() {
    animationController.dispose();
    super.dispose();
  }
}
