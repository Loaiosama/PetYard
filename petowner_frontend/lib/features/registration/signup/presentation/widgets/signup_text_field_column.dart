import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/custom_text_form_field.dart';

class SignUpTextFieldColumn extends StatelessWidget {
  const SignUpTextFieldColumn({
    super.key,
    required this.hintText,
    required this.labelText,
    this.width = double.infinity,
    this.keyboardType,
    this.isPassword = false,
    // required this.focusNode,
  });

  final String hintText;
  final String labelText;
  final double width;
  final TextInputType? keyboardType;
  final bool? isPassword;
  // final FocusNode focusNode;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 9.0.w),
          child: Text(
            labelText,
            style: Styles.styles16,
          ),
        ),
        SizedBox(height: 6.h),
        CustomRegistrationTextField(
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
