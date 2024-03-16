
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/fonts_helper.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

import 'pet_profile_circle.dart';

class ActivePetProfileSection extends StatelessWidget {
  const ActivePetProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const Divider(),
        heightSizedBox(16),
        RichText(
          text: TextSpan(
            text: 'Your Pets ',
            style: Styles.styles18SemiBoldBlack.copyWith(
                letterSpacing: 1.0,
                fontSize: 16.sp,
                fontWeight: FontsHelper.regular),
            children: [
              TextSpan(
                text: '2',
                style: Styles.styles22BoldGreen.copyWith(fontSize: 16.sp),
              ),
            ],
          ),
        ),
        heightSizedBox(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: List.generate(
                2,
                    (index) => InkWell(
                  onTap: () {},
                  child: const PetProfileCircle(),
                ),
              ),
            ),
            const PetProfileCircle(
              isAddNew: true,
            ),
          ],
        ),
        heightSizedBox(16),
        // const Divider(),
      ],
    );
  }
}
