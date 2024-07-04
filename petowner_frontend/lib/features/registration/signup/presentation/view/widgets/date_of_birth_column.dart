import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'date_of_birth_text_field.dart';

class DateOfBirthColumn extends StatelessWidget {
  const DateOfBirthColumn({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: EdgeInsets.only(left: 9.0.w),
        //   child: Text(
        //     'Date of Birth',
        //     style: Styles.styles16BoldBlack,
        //   ),
        //   // child: RichText(
        //   //   text: TextSpan(
        //   //     style: Styles.styles16,
        //   //     children: [
        //   //       const TextSpan(text: 'Date of Birth'),
        //   //       TextSpan(
        //   //         text: '*',
        //   //         style: Styles.styles14.copyWith(
        //   //           color: Colors.red,
        //   //         ),
        //   //       ),
        //   //     ],
        //   //   ),
        //   // ),
        // ),
        SizedBox(height: 6.h),
        DateOfBirthTexTField(
          controller: controller,
        ),
      ],
    );
  }
}
