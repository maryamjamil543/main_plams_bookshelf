import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/colors.dart';
import 'button_widget/custom_radio_listtile.dart';
class CustomRadioContainer extends StatelessWidget {
  final String groupValue;
  final ValueChanged<String?> onChanged;
  final String option1;
  final String option2;
  final String? option3;

  const CustomRadioContainer({
    Key? key,
    required this.groupValue,
    required this.onChanged,
    required this.option1,
    required this.option2,
    this.option3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: option3 == null ? 70.h : null, // Fixed height for 2 options, auto for 3
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: ColorUtils.greyColor,
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(
            color: ColorUtils.darkGreyColor,
          ),
        ),
        child: Center(
            child: option3 == null
                ? Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically in the center
              children: [
                CustomRadioListTile<String>(
                  value: option1,
                  groupValue: groupValue,
                  onChanged: onChanged,
                  labelText: option1,
                ),
                SizedBox(width: 8.w),
                CustomRadioListTile<String>(
                  value: option2,
                  groupValue: groupValue,
                  onChanged: onChanged,
                  labelText: option2,
                ),
              ],
            )
                : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch, // Make items take full width
              children: [
                CustomRadioListTile<String>(
                  value: option1,
                  groupValue: groupValue,
                  onChanged: onChanged,
                  labelText: option1,
                ),
                SizedBox(height: 4.h),
                CustomRadioListTile<String>(
                  value: option2,
                  groupValue: groupValue,
                  onChanged: onChanged,
                  labelText: option2,
                ),
                SizedBox(height: 4.h),
                if (option3 != null)
                  CustomRadioListTile<String>(
                    value: option3!,
                    groupValue: groupValue,
                    onChanged: onChanged,
                    labelText: option3!,
                  ),
              ],
            ),
            ),
    );
    }
}
