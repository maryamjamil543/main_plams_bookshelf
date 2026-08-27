import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_base/widgets/poppins_text_widget.dart';
import 'package:flutter_base/widgets/raleway_text_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdownSearch<T> extends ConsumerWidget {
  final List<T> items;
  final T? selectedItem;
  final Function(T?) onChanged;
  final String Function(T?) itemAsString;
  final Widget Function(BuildContext, T, bool)? itemBuilder;
  final double? popupHeight;
  final bool showSearchBox;
  final String? Function(T?)? onValidate;

  const CustomDropdownSearch({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.itemAsString,
    this.onValidate,
    this.popupHeight,
    this.itemBuilder,
    this.showSearchBox = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FocusManager.instance.primaryFocus?.unfocus();
    return SizedBox(
      height: 65,
      child: DropdownSearch<T>(
        popupProps: PopupProps.menu(
          menuProps: const MenuProps(
            backgroundColor: ColorUtils.whiteColor,
          ),
          itemBuilder: itemBuilder,
          showSearchBox: showSearchBox,
          searchFieldProps: TextFieldProps(
            decoration: dropdownDecoration("Search..."),
          ),
          constraints: BoxConstraints(maxHeight: popupHeight ?? 350.h),
        ),
        itemAsString: itemAsString,
        items: items,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: dropdownDecoration('Select'),
          // Custom decoration for the dropdown field
          baseStyle: GoogleFonts.raleway(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: ColorUtils.blackColor,
          ),
          textAlignVertical: TextAlignVertical.center,
        ),
        dropdownBuilder: (context, item) {
          return Container(
            padding: EdgeInsets.only(left: 2.w),
            child: RalewayTextWidget(
              fontsize: 15.sp,
              fontWeight: FontWeight.w400,
              color: ColorUtils.blackColor,
              text: itemAsString(item),
            ),
          );
        },
        onChanged: onChanged,
        selectedItem: selectedItem,
        validator: onValidate,
        dropdownButtonProps: DropdownButtonProps(
          icon: const Icon(Icons.keyboard_arrow_down),
          iconSize: 24.sp,
          color: ColorUtils.lightBlackColor,
        ),
      ),
    );
  }

  InputDecoration dropdownDecoration(String hintLabel) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: ColorUtils.darkGreyColor, width: 0.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: ColorUtils.darkGreyColor, width: 0.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(color: ColorUtils.redColor, width: 0.w
            // Error border color
            ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        // Set border radius to 50 for focused error state
        borderSide: BorderSide(color: ColorUtils.redColor, width: 0.w),
      ),
      filled: true,

      fillColor: ColorUtils.greyColor,

      // isCollapsed: true,

      contentPadding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 16.w),

      hintText: hintLabel,
    );
  }
}
