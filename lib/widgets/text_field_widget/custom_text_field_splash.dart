import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFieldSplash extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool readOnly;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? iconPath;
  final bool isSearchField;
  final List<TextInputFormatter>? inputFormatters;
  final bool isPasswordField;
  final bool isDateField;
  final TextInputAction textInputAction;
  final double? fontSize;
  final double? hintFontSize;
  final Color? hintColor;
  final Widget? prefixIconWidget;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final List<String>? autofillHints;

  CustomTextFieldSplash({
    Key? key,
    required this.controller,
    required this.labelText,
    this.readOnly = false,
    this.obscureText = false,
    required this.keyboardType,
    this.validator,
    this.iconPath,
    this.inputFormatters,
    this.isSearchField = false,
    this.isPasswordField = false,
    this.isDateField = false,
    this.textInputAction = TextInputAction.next,
    this.fontSize,         // optional
    this.hintFontSize,     // optional
    this.hintColor,
    this.prefixIconWidget,
   this.onChanged,
    this.onTap,
    this.suffixIcon,
    this.autofillHints
  }) : super(key: key);

  @override
  _CustomTextFieldSplashState createState() => _CustomTextFieldSplashState();
}

class _CustomTextFieldSplashState extends State<CustomTextFieldSplash> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      autofillHints: widget.autofillHints,
      obscureText: widget.isPasswordField ? _isObscure : false,
      style: TextStyle(
        fontFamily: 'Raleway',
        fontSize: widget.fontSize?.sp ?? 16.sp, // use custom font size if provided
        fontWeight: FontWeight.w400,
        color: ColorUtils.blackColor,
      ),
      decoration: InputDecoration(
        isDense: false,
        filled: true,
        fillColor:  ColorUtils.greyColor,// Yeh mandatory hai size kam karne ke liye
        hintText: widget.labelText,
        hintStyle: TextStyle(
          fontFamily: 'Raleway',
          fontSize: widget.hintFontSize?.sp ?? 15.sp,
          fontWeight: FontWeight.w400,
          color: widget.hintColor ?? ColorUtils.lightGrayBlueColor,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        // prefixIcon: widget.isSearchField
        //     ? (widget.prefixIconWidget != null
        //     ? SizedBox(
        //   height: 21.h,       // exact height you want
        //         // optional, keep it square
        //   child: Center(      // centers the icon inside the container
        //     child: widget.prefixIconWidget,
        //   ),
        // )
        //     : Icon(
        //   Icons.search,
        //   size: 21.h,
        //   color: widget.hintColor ?? ColorUtils.lightGrayBlueColor,
        // ))
          prefixIcon: widget.isDateField
              ? IconButton(
            icon: Icon(
              Icons.calendar_today,
              size: 16.h,
              color: widget.hintColor ?? ColorUtils.blackColor,
            ),
            onPressed: widget.onTap,
          )
              : widget.isSearchField
              ? (widget.prefixIconWidget != null
              ? SizedBox(
            height: 21.h,
            child: Center(
              child: widget.prefixIconWidget,
            ),
          )
              : Icon(
            Icons.search,
            size: 18.h,
            color: widget.hintColor ?? ColorUtils.lightGrayBlueColor,
          ))
                        : null,
        prefixIconConstraints: widget.isDateField
            ? BoxConstraints(minWidth: 24.w, minHeight: 24.h) // Date field icon
            : BoxConstraints(
          minWidth: 21.w,
          minHeight: 21.h,
          maxWidth: 32.w,
          maxHeight: 32.h,
        ), // Others



        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(   color: ColorUtils.darkGreyColor, width: 0.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(   color: ColorUtils.darkGreyColor,width: 0.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(   color: ColorUtils.darkGreyColor, width: 0.w),
        ),
        suffixIconConstraints: BoxConstraints(
          minHeight: 20.w,
          minWidth: 35.w,
        ),
        suffixIcon: widget.isPasswordField
            ? InkWell(
          onTap: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
          child: Icon(
            _isObscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 22.h,
            color: widget.hintColor ?? ColorUtils.lightGrayBlueColor,
          ),
        )
            : null,
      ),
      validator: widget.validator,
      readOnly: widget.readOnly,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      inputFormatters: widget.inputFormatters,
    );
  }
}
