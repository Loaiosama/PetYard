import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'date_of_birth_text_field.dart';

class DateOfBirthColumn extends StatelessWidget {
  const DateOfBirthColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 9.0.w),
          child: Text(
            'Date of Birth',
            style: Styles.styles18,
          ),
        ),
        SizedBox(height: 6.h),
        const DateOfBirthTexTField(),
      ],
    );
  }
}
