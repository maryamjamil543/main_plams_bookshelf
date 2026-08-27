import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/utils/colors.dart';
import 'package:flutter_base/widgets/poppins_text_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum DropdownDecorationType { Outline, Underline, Outline2 }

class CustomDropdownSearch<T> extends ConsumerWidget {
  final String? title;
  final String? urduTitle;
  final Color? titleTextColor;
  final double? titleFontSize;
  final List<T> items;
  final T? selectedItem;
  final Function(T?) onChanged;
  final String Function(T?)? itemAsString;
  final double? popupHeight;
  final String? Function(T?)? onValidate;
  final bool? enabled;
  final String? hintText;
  final EdgeInsets? contentPadding;
  bool? isTitleSpace;
  bool? isRequired;
  bool? isSearchable;
  DropdownDecorationType? dropdownDecorationType;

  CustomDropdownSearch({
    super.key,
    this.title,
    this.urduTitle,
    this.titleTextColor,
    this.titleFontSize,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    this.itemAsString,
    this.onValidate,
    this.popupHeight,
    this.enabled = true,
    this.hintText,
    this.contentPadding,
    this.isTitleSpace,
    this.isRequired,
    this.isSearchable,
    this.dropdownDecorationType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: title != null,
          child: Row(
            children: [
              SizedBox(
                width: (isTitleSpace ?? false) ? 8.w : 0.w,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        PoppinsTextWidget(
                          fontsize: titleFontSize ?? 12.sp,
                          fontWeight: FontWeight.w500,
                          color: titleTextColor ?? Colors.black,
                          text: title ?? "",
                        ),
                        Visibility(
                          visible: isRequired ?? false,
                          child: PoppinsTextWidget(
                            fontsize: titleFontSize ?? 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                            text: "*",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Visibility(
                          visible: (isRequired ?? false) && urduTitle != null,
                          child: PoppinsTextWidget(
                            fontsize: titleFontSize ?? 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                            text: "*",
                          ),
                        ),
                        PoppinsTextWidget(
                          fontsize: titleFontSize ?? 12.sp,
                          fontWeight: FontWeight.w500,
                          textAlign: TextAlign.end,
                          color: titleTextColor ?? Colors.black,
                          text: urduTitle ?? "",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: (isTitleSpace ?? false) ? 8.w : 0.w,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 6.h,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: dropdownDecorationType == DropdownDecorationType.Outline2
                ? [
                    // BoxShadow(
                    //   color: Colors.black.withOpacity(0.2),
                    //   offset: Offset(5, 5), // Shadow on bottom-left (to create depth)
                    //   blurRadius: 10,
                    //   spreadRadius: 0,
                    // ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), // Shadow color
                      offset: Offset(2, 3), // Shadow offset
                      blurRadius: 5, // Shadow blur radius
                      spreadRadius: 0, // Spread radius
                    ),
                  ]
                : [],
          ),
          child: DropdownSearch<T>(
            popupProps: PopupProps.menu(
              showSearchBox: isSearchable ?? false,
              searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 17.h,
                ),
              )),
              constraints: BoxConstraints(maxHeight: popupHeight ?? 350.h),
            ),
            enabled: enabled ?? true,
            itemAsString: itemAsString,
            items: items,
            dropdownDecoratorProps: DropDownDecoratorProps(
              // dropdownSearchDecoration: dropdownDecorationUnderline(
              //   "Select",
              // ),
              dropdownSearchDecoration: (dropdownDecorationType == DropdownDecorationType.Outline)
                  ? dropdownDecoration(
                      hintText ?? "Select",
                    )
                  : (dropdownDecorationType == DropdownDecorationType.Outline2)
                      ? dropdownDecoration2(
                          hintText ?? "Select",
                        )
                      : dropdownDecorationUnderline(hintText ?? "Select"),
              baseStyle: GoogleFonts.montserrat(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                // decorationColor: dropDownHintColor,
                color: Colors.black,
              ),
              textAlignVertical: TextAlignVertical.center,
              // textAlign: TextAlign.center
            ),
            dropdownBuilder: (context, item) {
              return Container(
                padding: EdgeInsets.only(left: 2.w),
                child: PoppinsTextWidget(
                  fontsize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black, // Assuming dropDownHintColor is defined elsewhere
                  text: itemAsString!(item) ?? "Select an item",
                ),
              );
            },
            onChanged: onChanged,
            selectedItem: selectedItem,
            validator: onValidate,
          ),
        ),
      ],
    );
  }

  InputDecoration dropdownDecoration(String hintLabel) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          width: 0.8,
          color: Colors.grey.withOpacity(0.4),
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.4),
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0.8,
          color:ColorUtils.textFieldBorderColor,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0.8,
          color: ColorUtils.redColor,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      // suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
      isCollapsed: true,
      contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: 18.h, horizontal: 14.w),
      hintText: hintLabel,
    );
  }

  InputDecoration dropdownDecoration2(String hintLabel) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          width: 0.8,
          color: Colors.grey.withOpacity(0.4),
        ),
        borderRadius: BorderRadius.circular(30.r),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.withOpacity(0.4),
        ),
        borderRadius: BorderRadius.circular(30.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0.8,
          color: ColorUtils.textFieldBorderColor,
        ),
        borderRadius: BorderRadius.circular(30.r),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 0.8,
          color: ColorUtils.redColor,
        ),
        borderRadius: BorderRadius.circular(30.r),
      ),
      // suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
      isCollapsed: true,
      contentPadding: contentPadding ?? EdgeInsets.symmetric(vertical: 18.h, horizontal: 14.w),
      hintText: hintLabel,
    );
  }

  InputDecoration dropdownDecorationUnderline(String hintLabel) {
    return InputDecoration(
      border: const UnderlineInputBorder(
        borderSide: BorderSide(
          color:ColorUtils.textFieldBorderColor,
        ),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color:ColorUtils.textFieldBorderColor,
        ),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: ColorUtils.redColor,
        ),
      ),
      // suffixIcon: Icon(Icons.keyboard_arrow_down_outlined),
      isCollapsed: true,
      contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 0.w),
      hintText: hintLabel,
    );
  }
}
