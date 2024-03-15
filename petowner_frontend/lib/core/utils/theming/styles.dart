import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/fonts_helper.dart';

class Styles {
  static TextStyle styles22BoldBlack = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontsHelper.bold,
    color: Colors.black,
  );
  static TextStyle styles22BoldGreen = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontsHelper.bold,
    color: kPrimaryGreen,
  );
  static TextStyle styles20BoldBlack = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontsHelper.bold,
    color: Colors.black,
  );

  static TextStyle styles18BoldBlack = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontsHelper.bold,
    color: Colors.black,
  );

  static TextStyle styles18SemiBoldBlack = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontsHelper.semiBold,
    color: Colors.black,
  );

  static TextStyle styles20SemiBoldBlack = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontsHelper.semiBold,
    color: Colors.black,
  );

  static TextStyle styles18MediumWhite = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontsHelper.medium,
    color: Colors.white,
  );
  static TextStyle styles16BoldBlack = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
  static TextStyle styles16w600 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
  static TextStyle styles14NormalBlack = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
  static TextStyle styles12NormalHalfBlack = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: Colors.black.withOpacity(0.5),
  );
  static TextStyle styles12RegularOpacityBlack = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontsHelper.regular,
    color: Colors.black.withOpacity(0.5),
  );
}
