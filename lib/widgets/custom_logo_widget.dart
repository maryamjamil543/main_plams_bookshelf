import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/image_assets.dart';

class CustomLogoWidget extends StatelessWidget {
  const CustomLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            //TODO:: logo icon
            Image.asset(
              plavsImage,
              height: 220.h,
              width: 300.w,
              // fit: BoxFit.contain,
            ),
            SizedBox(
              height: 50.h,
            ),
          ],
        );
  }
}
