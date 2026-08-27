import 'package:flutter/material.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_base/widgets/poppins_text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.title,
    this.icon,
    required this.onTap,
    required this.subtitle,
  });

  final String title;
  final SvgPicture? icon;
  final VoidCallback onTap;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120.h,
        width: 122.w,
        decoration: BoxDecoration(
          color: ColorUtils.greyColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: ColorUtils.lightGrey,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,  // Vertically centers content
          crossAxisAlignment: CrossAxisAlignment.center,  // Horizontally centers content
          children: [
            // Icon
            if (icon != null)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h), // Adjust space between icon and title
                child: icon,  // Display the icon
              ),

            // Title Text
            PoppinsTextWidget(
              fontsize: 18.sp,
              fontWeight: FontWeight.w600,
              color: ColorUtils.blackColor,
              text: title,
              textAlign: TextAlign.center,
            ),
            // Subtitle Text
            PoppinsTextWidget(
              fontsize: 12.sp,
              fontWeight: FontWeight.w400,
              color: ColorUtils.blackColor,
              text: subtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}


