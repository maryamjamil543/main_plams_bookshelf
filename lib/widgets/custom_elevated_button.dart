import 'package:flutter/material.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color backgroundColor;
  final Color? borderColor;
  final Color textColor;
  final double height;
  final double fontSize;
  final double borderRadius;

  const CustomElevatedButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.borderColor,
    this.icon,
    required this.backgroundColor,
    required this.textColor,
    this.height = 72.0,
    this.fontSize = 15.0,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        fixedSize: Size(double.infinity, height.h),
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: borderColor ?? ColorUtils.backgroundLight,
            width: 2.w,
          ),
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
      child: Text(
        buttonText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w700,
          color: textColor,
          fontSize: fontSize.sp,
        ),
      ),
    );
  }
}

