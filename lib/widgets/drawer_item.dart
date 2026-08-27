import 'package:flutter/material.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_base/widgets/poppins_text_widget.dart';
import 'package:flutter_base/widgets/raleway_text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerItemWidget extends StatelessWidget {
  const DrawerItemWidget({
    super.key,
    required this.title,
    this.iconData,
    this.iconWidget,
    this.onTap,
    this.color,
    this.iconSize,
    this.textSize,
    required this.isSelect,
  }) : assert(iconData != null || iconWidget != null, 'Provide either iconData or iconWidget');

  final String title;
  final IconData? iconData;
  final Widget? iconWidget;
  final VoidCallback? onTap;
  final Color? color;
  final double? iconSize;
  final double? textSize;
  final bool isSelect;

  @override
  Widget build(BuildContext context) {
    // Standardized fallback sizing for assets
    final double finalIconSize = iconSize ?? 24.h;

    final Widget displayedIcon = iconWidget != null
        ? SizedBox(
      height: finalIconSize,
      width: finalIconSize,
      child: iconWidget,
    )
        : Icon(
      iconData,
      size: finalIconSize,
      color: isSelect ? Colors.white : color ?? Colors.black,
    );

    return InkWell( // Switched to InkWell for cleaner touch feedback inside Drawers
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 72.w, // Accounts for the 54.w width + spacing offsets
              child: Align(
                alignment: Alignment.centerLeft,
                child: isSelect
                    ? Container(
                  height: 54.h,
                  width: 54.w,
                  decoration: BoxDecoration(
                    color: ColorUtils.darkGreenColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.r),
                      bottomRight: Radius.circular(30.r),
                    ),
                  ),
                  child: Center(child: displayedIcon),
                )
                    : Padding(
                  padding: EdgeInsets.only(left: 18.w),
                  child: displayedIcon,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: RalewayTextWidget(
                  fontsize: (textSize ?? 14).sp,
                  fontWeight: FontWeight.w600,
                  color: color ?? ColorUtils.blackColor,
                  text: title,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}