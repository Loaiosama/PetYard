import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class FirstSection extends StatelessWidget {
  const FirstSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back',
          style: Styles.styles22BoldGreen,
        ),
        SizedBox(height: 8.h),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Text(
            'We\'re excited to have you back, can\'t wait to see what you\'ve been to since you last logged in.',
            style: Styles.styles12,
          ),
        ),
        SizedBox(height: 14.h),
      ],
    );
  }
}
