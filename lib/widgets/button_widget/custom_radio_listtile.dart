import 'package:flutter/material.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomRadioListTile<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String labelText;

  const CustomRadioListTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Transform.translate(
        offset: Offset(-10.0.w, -15.0.h),
        child: RadioListTile<T>(
          // visualDensity: VisualDensity(horizontal: -4.0.w),
          activeColor: ColorUtils.darkGreenColor,
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          title: Text(
            labelText,
            style: TextStyle(
              color: ColorUtils.blackColor,
              fontSize: 14.0.sp,
            ),
            softWrap: true,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: -20.0.w),
        ),
      ),
    );
  }
}

