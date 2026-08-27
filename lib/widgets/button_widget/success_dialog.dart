import 'package:flutter/material.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../route/routes.dart';
import '../../utils/image_assets.dart';
import '../../utils/strings.dart';

import '../poppins_text_widget.dart';

class SuccessDialog extends StatelessWidget {
  final String message;

  const SuccessDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorUtils.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Minimize dialog size
          children: [
           Image.asset(successDialogIcon,height: 160.h),
            const SizedBox(height: 20),
            PoppinsTextWidget(
              fontsize: 20.sp,
              fontWeight: FontWeight.w600,
              color: ColorUtils.textColor3,
              text: successfullySubmittedText,
              textAlign: TextAlign.start,
            ),// Spacing

            const SizedBox(height: 10),
            PoppinsTextWidget(
              fontsize: 15.sp,
              fontWeight: FontWeight.w500,
              color: ColorUtils.lightBlackTextColor,
              text:message,
              textAlign: TextAlign.center,
            ),/// Spacing
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.DASHBOARD,
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorUtils.greyColor, // Background color
                fixedSize: Size(double.infinity, 74.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r), // Rounded corners
                  side: const BorderSide(color: ColorUtils.orangeColor, width: 1), // Optional border
                ),

              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    okayTextElevatedButton,
                    style: TextStyle(
                      fontFamily: 'Poppins', // Use Poppins font
                      fontWeight: FontWeight.w600,
                      color: ColorUtils.orangeColor, // Text color
                      fontSize: 15.sp, // Text size (responsive)
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )



          ],
        ),
      ),
    );
  }
}
