import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/custom_text_form_field.dart';

class SignUpTextFieldColumn extends StatelessWidget {
  const SignUpTextFieldColumn({
    super.key,
    required this.hintText,
    required this.labelText,
    this.width = double.infinity,
    this.keyboardType,
    this.isPassword = false,
    this.isObsecure,
    required this.controller,
    this.sufixIcon,
    // required this.focusNode,
  });
  final Widget? sufixIcon;
  final String hintText;
  final String labelText;
  final double width;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final bool? isPassword;
  final bool? isObsecure;
  // final FocusNode focusNode;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: EdgeInsets.only(left: 9.0.w),
        //   child: RichText(
        //     text: TextSpan(
        //       style: Styles.styles16BoldBlack,
        //       children: [
        //         TextSpan(text: labelText),
        //         TextSpan(
        //           text: '*',
        //           style: Styles.styles14NormalBlack.copyWith(
        //             color: Colors.red,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        SizedBox(height: 6.h),
        CustomRegistrationTextField(
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'This Field can\'t be empty!';
            }
            return null;
          },
          controller: controller,
          suffixIcon: sufixIcon,
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
