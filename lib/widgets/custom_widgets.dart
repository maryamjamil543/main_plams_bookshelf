import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_base/utils/image_assets.dart';
import 'package:flutter_base/widgets/poppins_text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showDialogForPickingSource(
    {required BuildContext context,
      onTapCamera,
      void Function()? onTapFile,
      bool isNOC = false,
    }) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        buttonPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        content: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              PoppinsTextWidget(fontsize: 18.sp, fontWeight: FontWeight.bold, color: ColorUtils.blackColor, text: "Choose Source"),

              SizedBox(
                height: 16.h,
              ),
              GestureDetector(
                onTap: onTapCamera,
                child: Container(
                  color: Colors.transparent,
                  height: 30.h,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Image.asset(
                       dialogueCamera,
                        height: 25,
                        width: 25,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      PoppinsTextWidget(fontsize: 16.sp, fontWeight: FontWeight.normal, color: ColorUtils.blackColor, text: "Take Photo"),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              GestureDetector(
                onTap: onTapFile,
                child: Container(
                  color: Colors.transparent,
                  height: 30.h,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Image.asset(
                        dialogueGallery,
                        height: 25,
                        width: 25,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      PoppinsTextWidget(fontsize: 16.sp, fontWeight: FontWeight.normal, color: ColorUtils.blackColor, text: "Choose File"),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
            ],
          ),
        ),
      );
    },
  );
}