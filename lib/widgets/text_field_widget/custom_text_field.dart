import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_base/providers/api_auth_notifier.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_base/utils/image_assets.dart';
import 'package:flutter_base/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool readOnly;
  final bool obscureText;
  final TextStyle hintTextStyle;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? iconPath;
  final List<TextInputFormatter>? inputFormatters;
  final bool isPasswordField;
  final bool isLocationField;
  final TextInputAction textInputAction;
  final bool isDateField;
  CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.readOnly = false,
    this.obscureText = false,
    required this.keyboardType,
    required this.hintTextStyle,
    this.validator,
    this.iconPath,
    this.inputFormatters,
    this.isPasswordField = false,
    this.isLocationField = false,
    this.textInputAction = TextInputAction.next,
    this.isDateField = false
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();



}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText; // Set initial state based on the `obscureText` parameter
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        setState(() {
          // Format and set the picked date to the controller
          widget.controller.text = DateFormat('yyyy-MM-dd').format(picked);
        });
      }
    }

    return TextFormField(
      onTap: () {
        if (widget.isDateField) {
          _selectDate(context);
        }
      },
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      obscureText: widget.isPasswordField ? _isObscure : false,
      inputFormatters: widget.inputFormatters,
      readOnly: widget.readOnly,
      style: TextStyle(
        fontFamily: 'Raleway', // Set font to Poppins
        fontWeight: FontWeight.w400, // Set font weight to 400
        fontSize: 18.sp, // Set font size to 14 for entered text
        color: ColorUtils.blackColor,
      ),
      decoration: InputDecoration(
        hintText: widget.labelText,
        hintStyle: TextStyle(
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: ColorUtils.hintColor,
        ),
        suffixIcon: widget.isDateField
            ? IconButton(
          icon: SvgPicture.asset(
            dateofbirthLogo,
            height: 24.0,
            width: 24.0,
          ),
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            _selectDate(context);
          },
        )
            : widget.isPasswordField
            ? IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility_off : Icons.visibility,
            color: ColorUtils.blackColor,
            size: 24.h,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ) :  widget.isLocationField
            ? IconButton(
          icon: Icon(
           Icons.location_on,
            size: 24.h,
            color: ColorUtils.greenColor,
          ),
          onPressed: () {
            setState(() {
              Utils.checkPermissionAndGetCurrentLocation(context, (location) {
                widget.controller.text = "${location.latitude},${location.longitude}";
              });
            });
          },
        ):null,
        filled: true,
        isDense: true,
        fillColor: ColorUtils.greyColor,
        contentPadding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w), // Inner padding set to 16
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: ColorUtils.darkGreyColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: ColorUtils.darkGreyColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: ColorUtils.darkGreyColor),
        ),
      ),
      validator: widget.validator,
    );
  }
}




