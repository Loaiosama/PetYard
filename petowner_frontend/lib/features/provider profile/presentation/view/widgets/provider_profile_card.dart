import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/features/home/presentation/view/widgets/pet_carer_card.dart';

import '../../../../../core/utils/theming/styles.dart';

class ProviderProfileCard extends StatelessWidget {
  const ProviderProfileCard({super.key, required this.providerName});
  final String providerName;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 80.h,
          width: 70.w,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(
                'assets/images/1.png',
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        widthSizedBox(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              providerName,
              style: Styles.styles16BoldBlack.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            heightSizedBox(6),
            Text(
              'Pet Sitter | Pet Walker | Pet Groomer',
              style: Styles.styles12NormalHalfBlack,
            ),
            heightSizedBox(8),
            const RatingRowWidget(),
          ],
        ),
        // widthSizedBox(10),
        // const Spacer(),
        // Padding(
        //   padding: EdgeInsets.only(right: 4.0.w),
        //   child: IconButton(
        //     onPressed: () {},
        //     icon: Tooltip(
        //       message: 'Send a message to Olivia.',
        //       child: Icon(
        //         FluentIcons.chat_20_regular,
        //         color: kPrimaryGreen,
        //         size: 28.0.sp,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
