import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/models/request/room_create/NewRoomCreateRequest.dart';
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
import '../../providers/api_add_new_room_notifier.dart';
import '../../utils/api_state_model.dart';
import '../../widgets/button_widget/success_dialog.dart';
import '../../widgets/custom_drop_down_search.dart';
import '../../widgets/custom_elevated_button.dart';

class AddRoomScreen extends ConsumerStatefulWidget {
  const AddRoomScreen({super.key});

  @override
  AddRoomScreenState createState() => AddRoomScreenState();
}

class AddRoomScreenState extends ConsumerState<AddRoomScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool canManageLibrary = false;

  @override
  void initState() {
    super.initState();
    // :: TODO check permission + load data when widgets tree loaded
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      refreshField();
      await _checkPermission();
      await _loadLibrary();
    });
  }

  //TODO :: only admin/owner/superadmin/librarian can add a room
  Future<void> _checkPermission() async {
    final userData = await Utils.getUserData();
    canManageLibrary = Utils.canAddBookFromUserData(userData);
    if (!canManageLibrary) {
      Navigator.pop(context);
      Utils.showToast(notAuthorizedText);
    }
  }

//TODO :: load all library dropdown list
  Future<void> _loadLibrary() async {
    final savedList = await Utils.getLibrariesList();

    if (savedList.isNotEmpty) {
      ref.read(typeOfLibraryListRoomStateProvider.notifier).state = savedList;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // :: TODO listen api responses
    ref.listen<ApiStatesModel>(apiCreateRoomNotifierProvider,
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
                  nameController.clear();
                  ref.refresh(selectedTypeOfLibraryRoom.notifier).state;

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
                height: 0.2.sh,
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
                    height: 0.16.sh,
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
                              //TODO :: add room text
                              RalewayTextWidget(
                                fontsize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.whiteColor,
                                text: addRoomText,
                              ),
                              const Spacer(),
                            ],
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
                                  //TODO :: add room text heading
                                  RalewayTextWidget(
                                    fontsize: 20.sp,
                                    fontWeight: FontWeight.w700,
                                    color: ColorUtils.mediumGrayColor,
                                    text: addRoomText,
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
                                items: ref
                                    .watch(typeOfLibraryListRoomStateProvider),
                                selectedItem:
                                ref.watch(selectedTypeOfLibraryRoom),
                                onChanged: (selectedItem) {
                                  ref
                                      .read(selectedTypeOfLibraryRoom.notifier)
                                      .state = selectedItem!;
                                },
                                itemAsString: (library) {
                                  if (library == null) {
                                    return "Not selected";
                                  } else {
                                    return library.name ?? "--select--";
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
                              SizedBox(height: 15.h),
                              //TODO :: room name heading text
                              RalewayTextWidget(
                                fontsize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorUtils.mediumGrayColor,
                                text: roomNameHeading,
                              ),
                              SizedBox(height: 10.h),
                              //TODO ::text field for room name
                              CustomTextFieldSplash(
                                controller: nameController,
                                labelText: roomNameHint,
                                textInputAction: TextInputAction.done,
                                fontSize: 25.sp,
                                hintColor: ColorUtils.lightBlackTextColor,
                                readOnly: false,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return enterRoomNameText;
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 30.h),
                              //TODO :: elevated button add new room
                              SizedBox(
                                width: double.infinity,
                                child: CustomElevatedButton(
                                  buttonText: addRoomText,
                                  onPressed: () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      _createRoom();
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
    ref.refresh(selectedTypeOfLibraryRoom.notifier).state;
  }

  // :: TODO create room api
  void _createRoom() async {
    if (await Utils.isInternetAvailable()) {
      String name = nameController.text.trim();
      CreateRoomRequestModel requestModel = CreateRoomRequestModel(
        libraryId: ref.read(selectedTypeOfLibraryRoom)?.id,
        name: name,
      );
      ref
          .read(apiCreateRoomNotifierProvider.notifier)
          .apiCreateRoom(requestModel);
    } else {
      Utils.showToast(networkErrorMessage);
    }
  }
}
