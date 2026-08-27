import 'package:flutter/material.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_base/widgets/poppins_text_widget.dart';
import 'package:flutter_base/widgets/raleway_text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
class CustomCardValueContainer extends StatelessWidget {
  const CustomCardValueContainer({
    super.key,
    required this.title,
    required this.subtitle,
    this.value,
    this.backgroundColor,
    this.icon,
    this.phoneNumber,
    required this.onTap,
    this.showSubscribeButton = true,
    this.subtitleMaxLines
  });

  final String title;
  final String subtitle;
  final String? phoneNumber;
  final String? value;
  final Color? backgroundColor;
  final Widget? icon;
  final VoidCallback onTap;
  final bool showSubscribeButton;
  final int? subtitleMaxLines;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 160.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r), // small radius
              border: Border.all(color: ColorUtils.backgroundLight),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 0,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r), // match container
              child: icon != null
                  ? SizedBox.expand(
                child: icon, // Image.asset / SvgPicture
              )
                  : Container(),
            ),
          ),
          SizedBox(height: 10.h),
          RalewayTextWidget(
            text: title,
            fontsize: 14.sp,
            fontWeight: FontWeight.w700,
            color: ColorUtils.mediumGrayColor,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          RalewayTextWidget(
            text: subtitle,
            fontsize: 14.sp,
            fontWeight: FontWeight.w400,
            color: ColorUtils.mediumGrayColor,
            textAlign: TextAlign.start,
            maxLines: subtitleMaxLines,
            overflow: TextOverflow.ellipsis,
          ),
          if (showSubscribeButton) ...[
            SizedBox(height: 15.h),
            SizedBox(
              height: 35.h,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorUtils.greenTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  "Subscribe",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}


