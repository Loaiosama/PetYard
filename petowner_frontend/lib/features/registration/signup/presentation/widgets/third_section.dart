import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'alternative_signup_option.dart';
import 'date_of_birth_column.dart';

class ThirdSection extends StatelessWidget {
  const ThirdSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const DateOfBirthColumn(),
        SizedBox(height: 16.h),
        PetYardTextButton(
          style: Styles.styles18.copyWith(color: Colors.white),
        ),
        SizedBox(height: 6.h),
        const ALternativeSignupOptionColumn(),
      ],
    );
  }
}
