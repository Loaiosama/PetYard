import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widgets/custom_text_form_field.dart';

class SignUpTextFieldColumn extends StatelessWidget {
  const SignUpTextFieldColumn({
    super.key,
    required this.hintText,
    this.labelText,
    this.width = double.infinity,
    this.keyboardType,
    this.isPassword = false,
    this.isPhone = false,
    this.isEmail = false,
    this.isObsecure,
    required this.controller,
    this.suffixIcon,
    // required this.focusNode,
  });

  final Widget? suffixIcon;
  final String hintText;
  final String? labelText;
  final double width;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final bool? isPassword;
  final bool? isPhone;
  final bool? isEmail;
  final bool? isObsecure;

  // final FocusNode focusNode;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 6.h),
        CustomRegistrationTextField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This field can\'t be empty!';
            }
            if (isPassword! && value.length < 8) {
              return 'This field must be at least 8 characters long!';
            }
            if (isPhone! && value.length != 11) {
              return 'This field must be 11 characters long!';
            }
            if (isEmail!) {
              String pattern = r'^[^@]+@[^@]+\.[^@]+$';
              RegExp regex = RegExp(pattern);
              if (!regex.hasMatch(value)) {
                return 'Please enter a valid email address!';
              }
            }
            return null;
          },
          controller: controller,
          suffixIcon: suffixIcon,
          isObsecure: isObsecure,
          hintText: hintText,
          width: width,
          keyboardType: keyboardType,
          isPassword: isPassword,
          // focusNode: focusNode,
        ),
      ],
    );
  }
}
