import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/colors.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final FormFieldValidator<T?>? validator;

  const CustomDropdown({
    Key? key,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color:ColorUtils.hintColor),
        filled: true,
        fillColor: ColorUtils.whiteColor,
        contentPadding:  EdgeInsets.symmetric(horizontal: 12.0.w), // Padding inside the dropdown
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color:ColorUtils.hintColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color:ColorUtils.hintColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color:ColorUtils.hintColor),
        ),
      ),
      items: items,
      onChanged: onChanged,
      validator: validator,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,),
      hint: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          hint,
          style: const TextStyle(color:ColorUtils.hintColor),
        ),
      ),
    );
  }
}
