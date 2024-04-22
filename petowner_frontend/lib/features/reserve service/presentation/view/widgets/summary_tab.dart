import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/provider%20profile/presentation/view/widgets/provider_profile_body.dart';

class SummaryTab extends StatelessWidget {
  const SummaryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking Information',
          style: Styles.styles14w600,
        ),
        heightSizedBox(16),
        //  const Color.fromRGBO(36, 124, 255, 1),
        // const Color.fromRGBO(34, 197, 94, 1),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SummaryIconContainer(
              containerColor: Color.fromRGBO(234, 242, 255, 1),
              iconColor: Color.fromRGBO(36, 124, 255, 1),
              icon: FontAwesomeIcons.solidCalendar,
            ),
            widthSizedBox(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date',
                  style: Styles.styles12w600,
                ),
                heightSizedBox(2),
                Text(
                  '-From Wednesday, 08 May 2023',
                  style: Styles.styles12NormalHalfBlack,
                ),
                Text(
                  '-To Friday, 10 May 2023',
                  style: Styles.styles12NormalHalfBlack,
                ),
              ],
            ),
          ],
        ),
        heightSizedBox(16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SummaryIconContainer(
              containerColor: Color.fromRGBO(233, 250, 239, 1),
              iconColor: Color.fromRGBO(34, 197, 94, 1),
              icon: Iconsax.clipboard_text4,
            ),
            widthSizedBox(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service',
                  style: Styles.styles12w600,
                ),
                heightSizedBox(2),
                Text(
                  'Pet Boarding',
                  style: Styles.styles12NormalHalfBlack,
                ),
              ],
            ),
          ],
        ),
        heightSizedBox(20),
        Text(
          'Pet Carer Information',
          style: Styles.styles14w600,
        ),
        heightSizedBox(16),
        const ProviderProfileCard(),
        heightSizedBox(20),
        Text(
          'Payment Information',
          style: Styles.styles14w600,
        ),
        heightSizedBox(16),
        Row(
          children: [
            const SummaryIconContainer(
              containerColor: Color.fromRGBO(255, 238, 239, 1),
              iconColor: Color.fromRGBO(255, 76, 94, 1),
              icon: Iconsax.wallet,
            ),
            widthSizedBox(10),
            Text(
              'Cash',
              style: Styles.styles12w600,
            ),
          ],
        ),
        heightSizedBox(20),
        Text(
          'Total Fees',
          style: Styles.styles14w600,
        ),
        heightSizedBox(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payment Total',
              style: Styles.styles12NormalHalfBlack,
            ),
            Text(
              '\$290/EG',
              style: Styles.styles14w600,
            ),
          ],
        )
      ],
    );
  }
}

class SummaryIconContainer extends StatelessWidget {
  const SummaryIconContainer(
      {super.key,
      required this.containerColor,
      required this.iconColor,
      required this.icon});
  final Color containerColor;
  final Color iconColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0.r),
        color: containerColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.0.h),
        child: Icon(
          icon,
          color: iconColor,
          size: 20.sp,
        ),
      ),
    );
  }
}
