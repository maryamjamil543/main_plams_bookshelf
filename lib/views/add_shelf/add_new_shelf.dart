import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/models/request/shelf_create/NewShelfCreateRequest.dart';
import 'package:flutter_base/models/response/login_response/LibraryLogin.dart';
import 'package:flutter_base/models/response/login_response/Room.dart';
import 'package:flutter_base/models/states.dart';
import 'package:flutter_base/providers/api_add_new_shelf_notifier.dart';
import 'package:flutter_base/repository/auth_repository.dart';
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
import '../../utils/api_state_model.dart';
import '../../widgets/button_widget/success_dialog.dart';
import '../../widgets/custom_drop_down_search.dart';
import '../../widgets/custom_elevated_button.dart';


// Selected Library
final selectedTypeOfLibraryShelf =
StateProvider<LibraryLogin>((ref) => LibraryLogin());

// Library list
final typeOfLibraryListShelfStateProvider =
StateProvider<List<LibraryLogin>>((ref) => []);


// Selected Room
final selectedRoomShelf =
StateProvider<Room>((ref) => Room());

// Room list
final roomListShelfStateProvider =
StateProvider<List<Room>>((ref) => []);


class AddShelfScreen extends ConsumerStatefulWidget {
  const AddShelfScreen({super.key});

  @override
  AddShelfScreenState createState() => AddShelfScreenState();
}


class AddShelfScreenState extends ConsumerState<AddShelfScreen> {

  final nameController = TextEditingController();
  final capacityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool canManageLibrary = false;


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      refreshField();

      await _checkPermission();

      await _loadLibrary();

      await _loadRooms();
    });
  }


  // TODO :: only authorized users can add shelf
  Future<void> _checkPermission() async {

    final userData = await Utils.getUserData();

    canManageLibrary =
        Utils.canAddBookFromUserData(userData);

    if (!canManageLibrary) {

      Navigator.pop(context);

      Utils.showToast(notAuthorizedText);
    }
  }


  // TODO :: load libraries
  Future<void> _loadLibrary() async {

    final savedList =
    await Utils.getLibrariesList();

    if (savedList.isNotEmpty) {

      ref
          .read(typeOfLibraryListShelfStateProvider.notifier)
          .state = savedList;
    }
  }


  // TODO :: load rooms
  Future<void> _loadRooms() async {

    try {

      final rooms =
      await ref.read(authRepository).getAllRooms();

      if (rooms.isNotEmpty) {

        ref
            .read(roomListShelfStateProvider.notifier)
            .state = rooms;
      }

    } catch (error) {

      Utils.printInDebug(
        "Error loading rooms: $error",
      );
    }
  }


  @override
  void dispose() {

    nameController.dispose();

    capacityController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    // TODO :: listen API response
    ref.listen<ApiStatesModel>(
      apiCreateShelfNotifierProvider,
          (previous, apiStatesModel) {

        switch (apiStatesModel.states) {

          case States.ERROR:

            ScaffoldMessenger.of(context)
                .showSnackBar(
              SnackBar(
                content:
                Text(apiStatesModel.message),
              ),
            );

            break;


          case States.DATA:

            if (apiStatesModel.data
            is ServerResponse) {

              final response =
              apiStatesModel.data
              as ServerResponse;

              final isSuccess =
                  response.statusCode == 201;


              if (isSuccess) {

                nameController.clear();

                capacityController.clear();

                ref.refresh(
                  selectedTypeOfLibraryShelf
                      .notifier,
                ).state;

                ref.refresh(
                  selectedRoomShelf.notifier,
                ).state;


                showDialog(
                  context: context,
                  builder: (context) {

                    return SuccessDialog(
                      message:
                      response.message ??
                          "Success",
                    );
                  },
                );

              } else {

                final errorMessage =
                (response.error != null &&
                    response.error
                        .toString()
                        .isNotEmpty)
                    ? response.error.toString()
                    : response.message ??
                    "Something went wrong";


                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content:
                    Text(errorMessage),
                  ),
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
      },
    );


    return Stack(
      children: [

        _mainLayout(),

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

        backgroundColor:
        ColorUtils.whiteColor,


        body: Stack(

          children: [

            // TODO :: background image
            ClipRRect(

              borderRadius:
              BorderRadius.only(
                bottomLeft:
                Radius.circular(30.r),
                bottomRight:
                Radius.circular(30.r),
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

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  // Header
                  SizedBox(

                    height: 0.16.sh,

                    child: Padding(

                      padding:
                      EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 24.h,
                      ),

                      child: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          SizedBox(
                            height: 30.h,
                          ),


                          Row(

                            children: [

                              InkWell(

                                onTap: () =>
                                    Navigator.pop(
                                        context),

                                child:
                                SvgPicture.asset(
                                  backArrow,
                                  height: 35.h,
                                ),
                              ),


                              SizedBox(
                                width: 20.w,
                              ),


                              RalewayTextWidget(
                                fontsize: 20.sp,
                                fontWeight:
                                FontWeight.w700,
                                color: ColorUtils
                                    .whiteColor,
                                text:
                                addShelfText,
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

                      padding:
                      EdgeInsets.only(
                        left: 15.w,
                        right: 15.w,
                      ),

                      child:
                      SingleChildScrollView(

                        child: Form(

                          key: _formKey,

                          child: Column(

                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                            children: [

                              SizedBox(
                                height: 10.h,
                              ),


                              RalewayTextWidget(
                                fontsize: 20.sp,
                                fontWeight:
                                FontWeight.w700,
                                color: ColorUtils
                                    .mediumGrayColor,
                                text:
                                addShelfText,
                              ),


                              SizedBox(
                                height: 20.h,
                              ),


                              // =====================
                              // LIBRARY
                              // =====================

                              RalewayTextWidget(
                                fontsize: 16.sp,
                                fontWeight:
                                FontWeight.w700,
                                color: ColorUtils
                                    .mediumGrayColor,
                                text:
                                libraryTypeText,
                              ),


                              SizedBox(
                                height: 10.h,
                              ),


                              CustomDropdownSearch(

                                showSearchBox: false,

                                items: ref.watch(
                                  typeOfLibraryListShelfStateProvider,
                                ),

                                selectedItem: ref.watch(
                                  selectedTypeOfLibraryShelf,
                                ),

                                onChanged:
                                    (selectedItem) {

                                  ref
                                      .read(
                                    selectedTypeOfLibraryShelf
                                        .notifier,
                                  )
                                      .state =
                                  selectedItem!;
                                },


                                itemAsString:
                                    (library) {

                                  if (library ==
                                      null) {

                                    return "Not selected";
                                  }

                                  return library.name ??
                                      "--select--";
                                },


                                onValidate:
                                    (value) {

                                  if (value ==
                                      null) {

                                    return selectTypeOfLibrary;
                                  }

                                  if (value.name ==
                                      null ||
                                      value.name!
                                          .toLowerCase()
                                          .contains(
                                          "please")) {

                                    return selectTypeOfLibrary;
                                  }

                                  return null;
                                },
                              ),


                              SizedBox(
                                height: 15.h,
                              ),


                              // =====================
                              // ROOM
                              // =====================

                              RalewayTextWidget(
                                fontsize: 16.sp,
                                fontWeight:
                                FontWeight.w700,
                                color: ColorUtils
                                    .mediumGrayColor,
                                text:
                                roomHeading,
                              ),


                              SizedBox(
                                height: 10.h,
                              ),


                              CustomDropdownSearch(

                                showSearchBox: true,

                                items: ref.watch(
                                  roomListShelfStateProvider,
                                ),

                                selectedItem: ref.watch(
                                  selectedRoomShelf,
                                ),

                                onChanged:
                                    (selectedItem) {

                                  ref
                                      .read(
                                    selectedRoomShelf
                                        .notifier,
                                  )
                                      .state =
                                  selectedItem!;
                                },


                                itemAsString:
                                    (room) {

                                  if (room ==
                                      null) {

                                    return "Not selected";
                                  }

                                  return room.name ??
                                      "--select--";
                                },


                                onValidate:
                                    (value) {

                                  if (value ==
                                      null) {

                                    return selectRoomError;
                                  }

                                  if (value.name ==
                                      null) {

                                    return selectRoomError;
                                  }

                                  return null;
                                },
                              ),


                              SizedBox(
                                height: 15.h,
                              ),


                              // =====================
                              // SHELF NAME
                              // =====================

                              RalewayTextWidget(
                                fontsize: 16.sp,
                                fontWeight:
                                FontWeight.w700,
                                color: ColorUtils
                                    .mediumGrayColor,
                                text:
                                shelfNameHeading,
                              ),


                              SizedBox(
                                height: 10.h,
                              ),


                              CustomTextFieldSplash(

                                controller:
                                nameController,

                                labelText:
                                shelfNameHint,

                                textInputAction:
                                TextInputAction.next,

                                fontSize: 25.sp,

                                hintColor: ColorUtils
                                    .lightBlackTextColor,

                                readOnly: false,

                                keyboardType:
                                TextInputType.text,

                                validator: (value) {

                                  if (value ==
                                      null ||
                                      value
                                          .trim()
                                          .isEmpty) {

                                    return enterShelfNameText;
                                  }

                                  return null;
                                },
                              ),


                              SizedBox(
                                height: 15.h,
                              ),


                              // =====================
                              // CAPACITY
                              // =====================

                              RalewayTextWidget(
                                fontsize: 16.sp,
                                fontWeight:
                                FontWeight.w700,
                                color: ColorUtils
                                    .mediumGrayColor,
                                text:
                                capacityHeading,
                              ),


                              SizedBox(
                                height: 10.h,
                              ),


                              CustomTextFieldSplash(

                                controller:
                                capacityController,

                                labelText:
                                capacityHint,

                                textInputAction:
                                TextInputAction.done,

                                fontSize: 25.sp,

                                hintColor: ColorUtils
                                    .lightBlackTextColor,

                                readOnly: false,

                                keyboardType:
                                TextInputType.number,

                                inputFormatters: [

                                  FilteringTextInputFormatter
                                      .digitsOnly,
                                ],

                                validator: (value) {

                                  if (value ==
                                      null ||
                                      value
                                          .trim()
                                          .isEmpty) {

                                    return enterCapacityText;
                                  }

                                  final capacity =
                                  int.tryParse(
                                      value);

                                  if (capacity ==
                                      null ||
                                      capacity <= 0) {

                                    return "Please enter a valid capacity";
                                  }

                                  return null;
                                },
                              ),


                              SizedBox(
                                height: 30.h,
                              ),


                              // =====================
                              // ADD SHELF BUTTON
                              // =====================

                              SizedBox(

                                width:
                                double.infinity,

                                child:
                                CustomElevatedButton(

                                  buttonText:
                                  addShelfText,

                                  onPressed: () {

                                    if (_formKey
                                        .currentState
                                        ?.validate() ??
                                        false) {

                                      _createShelf();
                                    }
                                  },

                                  backgroundColor:
                                  ColorUtils
                                      .lightGreenColor,

                                  borderColor:
                                  ColorUtils
                                      .lightGreenColor,

                                  textColor:
                                  ColorUtils
                                      .whiteColor,

                                  height: 80.h,

                                  fontSize: 28.sp,
                                ),
                              ),


                              SizedBox(
                                height: 10.h,
                              ),
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


  // TODO :: clear fields
  void refreshField() {

    ref.refresh(
      selectedTypeOfLibraryShelf.notifier,
    ).state;

    ref.refresh(
      selectedRoomShelf.notifier,
    ).state;
  }


  // TODO :: create shelf API
  void _createShelf() async {

    if (await Utils.isInternetAvailable()) {

      final name =
      nameController.text.trim();

      final capacity =
      int.tryParse(
          capacityController.text.trim());


      if (capacity == null) {

        Utils.showToast(
          "Please enter a valid capacity",
        );

        return;
      }


      final requestModel =
      CreateShelfRequestModel(

        libraryId:
        ref.read(
          selectedTypeOfLibraryShelf,
        )?.id,

        roomId:
        ref.read(
          selectedRoomShelf,
        )?.id,

        name: name,

        capacity: capacity,
      );


      ref
          .read(
        apiCreateShelfNotifierProvider
            .notifier,
      )
          .apiCreateShelf(
        requestModel,
      );

    } else {

      Utils.showToast(
        networkErrorMessage,
      );
    }
  }
}