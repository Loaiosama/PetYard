import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

import 'signup_username_widget.dart';

class FirstSection extends StatelessWidget {
  const FirstSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Let\'s get started!',
          style: Styles.styles24.copyWith(color: kPrimaryGreen),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Text(
            'Create an account now to use all of PetYard services.',
            style: Styles.styles14,
          ),
        ),
        SizedBox(height: 14.h),
        const SignUpUserNameWidget(),
      ],
    );
  }
}
