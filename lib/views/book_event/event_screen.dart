import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/models/response/sync/SyncResponse.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/providers/api_events_notifier.dart';
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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/response/event/Events.dart';
import '../../models/response/login_response/LibraryLogin.dart';
import '../../models/response/server_response.dart';
import '../../utils/api_state_model.dart';
import 'event_register_screen.dart';

class EventScreen extends ConsumerStatefulWidget {
  const EventScreen({super.key});

  @override
  EventScreenState createState() => EventScreenState();
}

class EventScreenState extends ConsumerState<EventScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final searchController = TextEditingController();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  String? role;
  bool canAddBook = false;
//TODO :: get list of event
  List<Event> _getApiEvents() {
    final apiEvents = ref.watch(eventsProvider);
    return apiEvents
        .map((event) => Event(
            id: event.id,
            libraryId: event.libraryId,
            attendeesCount: event.attendeesCount,
            title: event.title ?? 'N/A',
            location: event.location ?? 'N/A',
            feeAmount: event.feeAmount != null ? (event.feeCurrency != null ?
            "${event.feeCurrency} ${event.feeAmount}" : event.feeAmount.toString()) : '0.00',
            startDate: event.startDate ?? DateTime.now(),
            endDate: event.endDate ?? DateTime.now(),
            speakers: event.speakers ?? "N/A"))
        .toList();
  }
//TODO :: event list for days
  List<Event> _getEventsForDay(DateTime day) {
    final events = _getApiEvents();

    return events.where((event) {
      final start = DateTime(
        event.startDate!.year,
        event.startDate!.month,
        event.startDate!.day,
      );

      final end = DateTime(
        event.endDate!.year,
        event.endDate!.month,
        event.endDate!.day,
      );

      final selected = DateTime(day.year, day.month, day.day);

      return !selected.isBefore(start) && !selected.isAfter(end);
    }).toList();
  }
//TODO :: date or time
  String formatDateTime(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} "
        "${dt.hour > 12 ? dt.hour - 12 : dt.hour}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}";
  }
  @override
  void initState() {
    super.initState();
    // :: TODO sync data when widgets tree loaded
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userData = await Utils.getUserData();
      canAddBook = Utils.canAddBookFromUserData(userData);
      // :: TODO api call for fetch event list
      if (await Utils.isInternetAvailable()) {
        await ref.read(apiEventsNotifierProvider.notifier).fetchEvents();
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
    ref.listen<ApiStatesModel>(apiEventsNotifierProvider,
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
          } else if (apiStatesModel.data is ServerResponse) {
            final response = apiStatesModel.data as ServerResponse;

            if (response.status == true) {
              Fluttertoast.showToast(
                msg: response.message ?? "Success",
                toastLength: Toast.LENGTH_SHORT,
              );
            } else {
              if (response.message != null) {
                Fluttertoast.showToast(
                    msg: response.message!, toastLength: Toast.LENGTH_SHORT);
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorUtils.whiteColor,
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
                height: 0.27.sh,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
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
                            // :: TODO back arrow icon
                            children: [
                              InkWell(
                                onTap: () => Navigator.pop(context),
                                child: SvgPicture.asset(
                                  backArrow,
                                  height: 35.h,
                                ),
                              ),
                              SizedBox(width: 20.w),
                              // :: TODO event text heading
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
                          // :: TODO search text field filter the event list
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
                                      prefixIconWidget: Icon(
                                        Icons.search,
                                        size: 20.sp,
                                        color: ColorUtils.lightBlackTextColor,
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
                    child: ListView(
                      children: [
                        //TODO :: Calendar
                        TableCalendar(
                          firstDay: DateTime.utc(2023, 1, 1),
                          lastDay: DateTime.utc(2030, 12, 31),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) =>
                              isSameDay(day, _selectedDay),
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          },
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                          ),
                          calendarStyle: const CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: ColorUtils.lightGrayBlueColor,
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: ColorUtils.greenTextColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          eventLoader: (day) {
                            return _getEventsForDay(day);
                          },
                          calendarBuilders: CalendarBuilders(
                            markerBuilder: (context, day, events) {
                              if (events.isEmpty) return const SizedBox();
                              // :: TODO showing event item
                              return Positioned(
                                bottom: 1,
                                child: Container(
                                  padding:  EdgeInsets.all(4.r),
                                  decoration:  BoxDecoration(
                                    color: ColorUtils.greenColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    events.length.toString(),
                                    style:  TextStyle(
                                      color: ColorUtils.whiteColor,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 12.h),

                        //TODO :: Events List
                        ..._getEventsForDay(_selectedDay).map((event) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: ColorUtils.lightYellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                    //TODO :: LEFT SIDE
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RalewayTextWidget(
                                            fontsize: 20.sp,
                                            fontWeight: FontWeight.w700,
                                            color: ColorUtils.mediumGrayColor,
                                            text: event.title ?? "",
                                          ),
                                          SizedBox(height: 4.h),
                                          RalewayTextWidget(
                                            fontsize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: ColorUtils.mediumGrayColor,
                                            text: event.location ?? "",
                                          ),
                                          SizedBox(height: 4.h),
                                          RalewayTextWidget(
                                            fontsize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: ColorUtils.lightBlackColor,
                                            text:
                                            "${formatDateTime(event.startDate!)} – ${formatDateTime(event.endDate!)}",
                                          ),
                                          SizedBox(height: 4.h),
                                          RalewayTextWidget(
                                            fontsize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: ColorUtils.mediumGrayColor,
                                            text: getFeeText(event),
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(width: 12.w),

                                    //TODO :: RIGHT SIDE BUTTON (FIXED LOGIC) showing permission base
                                    FutureBuilder<List<LibraryLogin>>(
                                      future: Utils.getLibrariesList(),
                                      builder: (context, snapshot) {
                                        final libraries = snapshot.data ?? [];

                                        final isOwnLibrary = libraries.any(
                                              (lib) => lib.id == event.libraryId,
                                        );

                                        final canManage = isOwnLibrary && canAddBook;

                                        if (canManage) {
                                          return ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: ColorUtils.greenTextColor,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 16.w,
                                                vertical: 10.h,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8.r),
                                              ),
                                            ),
                                            child: RalewayTextWidget(
                                              fontsize: 15.sp,
                                              fontWeight: FontWeight.w600,
                                              color: ColorUtils.whiteColor,
                                              text:
                                              "${AttendeesText ?? ''} (${event.attendeesCount ?? 0})",
                                            ),
                                          );
                                        }
                                        //TODO :: event register screen
                                        return ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    EventRegisterScreen(event: event),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: ColorUtils.greenColor,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16.w,
                                              vertical: 10.h,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.r),
                                            ),
                                          ),
                                          //TODO :: register text
                                          child: RalewayTextWidget(
                                            fontsize: 13.sp,
                                            fontWeight: FontWeight.w600,
                                            color: ColorUtils.whiteColor,
                                            text: registerText,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  //TODO :: Show Fine Amount
  String getFeeText(Event event) {
    final amount = event.feeAmount;

    //TODO :: FREE cases
    if (amount == null ||
        amount == "0" ||
        amount == "0.0" ||
        amount == "0.00") {
      return "FREE";
    }

    //TODO :: PAID cases
    if (event.feeCurrency != null) {
      return "${event.feeCurrency} $amount";
    }
    return amount.toString();
  }
}
