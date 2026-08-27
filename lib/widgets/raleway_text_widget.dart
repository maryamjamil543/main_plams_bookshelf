import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class RalewayTextWidget extends StatelessWidget {
  double fontsize;
  FontWeight fontWeight;
  Color color;
  String text;
  TextDecoration? textDecoration;
  double? height;
  TextAlign? textAlign;
  int? maxLines;
  final TextOverflow? overflow;

  RalewayTextWidget({
    super.key,
    required this.fontsize,
    required this.fontWeight,
    required this.color,
    required this.text,
    this.textDecoration,
    this.maxLines,
    this.height,
    this.textAlign,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines ?? 12,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.raleway(
        fontSize: fontsize,
        fontWeight: fontWeight,
        height: height,
        decoration: textDecoration ?? TextDecoration.none,
        decorationColor: color,
        color: color,
      ),
    );
  }
}
