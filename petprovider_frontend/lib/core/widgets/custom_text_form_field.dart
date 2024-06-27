// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/theming/colors.dart';
import '../utils/theming/styles.dart';

InputBorder customEnabledOutlinedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0.r),
  borderSide: BorderSide(
    color: Colors.black.withOpacity(0.2),
    width: 2.0,
  ),
);

InputBorder customFocusedOutlinedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0.r),
  borderSide: const BorderSide(
    // color: Color.fromRGBO(0, 170, 91, 1),
    color: kPrimaryGreen,
    width: 2.0,
  ),
);
InputBorder customErrorOutlinedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(10.0.r),
  borderSide: const BorderSide(
    color: Colors.red,
    width: 2.0,
  ),
);

class CustomRegistrationTextField extends StatelessWidget {
  const CustomRegistrationTextField({
    super.key,
    this.hintText = 'HINT',
    this.keyboardType,
    required this.width,
    required this.controller,
    this.height = 60,
    this.isPassword = false,
    this.isObsecure,
    this.validator,
    this.suffixIcon,
    this.onChanged,
    this.prefixIcon,
  });

  final String hintText;
  final TextInputType? keyboardType;
  final double width;
  final double height;
  final bool? isPassword;
  final bool? isObsecure;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool isVisible = false;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {},
      controller: controller,
      validator: validator,
      obscureText: isObsecure ?? false,
      style: Styles.styles14NormalBlack
          .copyWith(color: const Color.fromRGBO(0, 85, 45, 1)),
      keyboardType: keyboardType,
      scrollPadding: EdgeInsets.all(10),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        constraints: BoxConstraints.tightForFinite(width: width),
        suffixIcon: suffixIcon,
        prefix: prefixIcon,
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontSize: 14.sp,
        ),
        enabledBorder: customEnabledOutlinedBorder,
        focusedBorder: customFocusedOutlinedBorder,
        errorBorder: customErrorOutlinedBorder,
        border: customEnabledOutlinedBorder,
      ),
    );
  }
}
