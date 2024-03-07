// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

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
    color: Color.fromRGBO(0, 170, 91, 1),
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
    this.height = 60,
    this.isPassword = false,
    this.isObsecure,
    required this.controller,
    this.validator,
    this.suffixIcon,
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
  final bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field can\'t be empty';
        }
        return null;
      },
      obscureText: isObsecure ?? false,
      style:
          Styles.styles14.copyWith(color: const Color.fromRGBO(0, 85, 45, 1)),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        // backgroud color to textformfield (in consider)
        // fillColor: Colors.grey.shade100,
        // filled: true,

        //is Dense is like the padding inside of the field
        isDense: true,
        // contentPadding:
        //     const EdgeInsets.symmetric(vertical: 16, horizontal: 14),

        hintText: hintText,
        constraints: BoxConstraints.tightForFinite(
          width: width,
        ),
        suffixIcon: suffixIcon,
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
