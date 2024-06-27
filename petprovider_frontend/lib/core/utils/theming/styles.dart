import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';
import 'fonts_helper.dart';


class Styles {
  static TextStyle styles14NormalBlack = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static TextStyle styles16w600 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  static TextStyle styles12NormalHalfBlack = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: Colors.black.withOpacity(0.5),
  );
  static TextStyle styles22BoldGreen = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontsHelper.bold,
    color: kPrimaryGreen,
  );
  static TextStyle styles16BoldWhite = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );
  static TextStyle styles16BoldBlack = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );
}
