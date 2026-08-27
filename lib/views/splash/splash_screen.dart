import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/providers/api_auth_notifier.dart';
import 'package:flutter_base/providers/api_splash_notifier.dart';
import 'package:flutter_base/route/routes.dart';
import 'package:flutter_base/utils/image_assets.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/response/server_response.dart';
import '../../models/response/sync/SyncResponse.dart';
import '../../models/states.dart';
import '../../providers/api_register_notifier.dart';
import '../../utils/api_state_model.dart';
import '../../utils/strings.dart';
import '../../widgets/dialog_widget/dialog_widget.dart';
import '../../widgets/loading_widget.dart';


class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // :: TODO navigate screen after 3 seconds
    Timer(const Duration(seconds: 3), () async {
      if (!await Utils.isInternetAvailable()) {
        DialogBuilder.showNoInternetDialog(
            noInternetText,
            checkInternetText,
            context, () => SystemNavigator.pop());
        return;
      }
      await loadFormListData();
      bool isLoggedIn = await Utils.getIsLoggedIn();
      Utils.printInDebug(isLoggedIn);
      if (!isLoggedIn) {
        // :: TODO login screen
        _navigateTo(Routes.LOGIN);
      } else {
        // :: TODO dashboard screen
        _navigateTo(Routes.DASHBOARD);
      }
    });
  }
  Future<void> loadFormListData() async {
    await ref.read(apiSplashNotifierProvider.notifier).getApiSyncData();
  }


@override
void dispose() {
  super.dispose();
}
@override
Widget build(BuildContext context) {
  // :: TODO listen api responses
  ref.listen<ApiStatesModel>(apiSplashNotifierProvider,
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
  return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child:Scaffold(
      body: Stack(
        children: [

          // :: TODO splash background image
          Positioned.fill(
            child: Image.asset(
                splashBackground,
              fit: BoxFit.cover,

            ),
          ),

          Center(
            child: Column(

              children: [
                // :: TODO Book Shelf  app logo
                SizedBox(height: 150.h,),
                Image.asset(
                  plavsImage,
                  height: 400.h,
                  width: 450.w,
                  // fit: BoxFit.contain,
                ),
              ],
            ),
          ),

        ],
      ),
      ),
    );
  }
// :: TODO check permissions
  Future<void> checkPermissions() async {
    await Permission.location.request();
    await Permission.locationAlways.request();
    await Permission.locationWhenInUse.request();
    await Permission.location.request();
  }

  // :: TODO navigate screen
  _navigateTo(String routeName) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false);
  }
}
