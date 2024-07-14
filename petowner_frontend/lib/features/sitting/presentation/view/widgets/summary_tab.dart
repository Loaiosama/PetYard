import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class Summary extends StatelessWidget {
  final DateTime? startTime;
  final DateTime? endTime;
  final String? PteName;
  final int? petId;
  final double? pricee;
  const Summary(
      {super.key,
      this.startTime,
      required this.endTime,
      required this.PteName,
      required this.petId,
      required this.pricee});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10.h,
        ),
        Text(
          "Request Information",
          style: Styles.styles14w600,
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SummaryItem(
              containerColor: Color.fromRGBO(234, 242, 255, 1),
              iconColor: Color.fromRGBO(36, 124, 255, 1),
              icon: FontAwesomeIcons.solidCalendar,
            ),
            SizedBox(
              height: 10.w,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 17.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date',
                    style: Styles.styles12w600,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    '- From ${DateFormat('EEE, d, MMM ,yyyy, hh:mm a').format(startTime ?? DateTime.now())}',
                    style: Styles.styles12NormalHalfBlack,
                  ),
                  Text(
                    '- To ${DateFormat('EEE, d, MMM, yyyy, hh:mm a').format(endTime ?? DateTime.now())}',
                    style: Styles.styles12NormalHalfBlack,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 25.h,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SummaryItem(
              containerColor: Color.fromRGBO(233, 250, 239, 1),
              iconColor: Color.fromRGBO(34, 197, 94, 1),
              icon: Iconsax.clipboard_text4,
            ),
            SizedBox(
              width: 10.w,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Service",
                    style: Styles.styles12w600,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    "Pet Sitting",
                    style: Styles.styles12NormalHalfBlack,
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 25.h,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SummaryItem(
              containerColor: Color.fromRGBO(250, 233, 250, 1),
              iconColor: Color.fromRGBO(197, 34, 170, 1),
              icon: FontAwesomeIcons.paw,
            ),
            SizedBox(
              width: 10.w,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pet',
                    style: Styles.styles12w600,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    PteName ?? "No Name",
                    style: Styles.styles12NormalHalfBlack,
                  )
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 25.h,
        ),
        Row(
          children: [
            const SummaryItem(
              containerColor: Color.fromRGBO(255, 238, 239, 1),
              iconColor: Color.fromRGBO(255, 76, 94, 1),
              icon: Iconsax.wallet,
            ),
            SizedBox(
              height: 3.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Payment Method",
                    style: Styles.styles12w600,
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    'Cash',
                    style: Styles.styles12NormalHalfBlack,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 35.h,
        ),
        Text(
          'Total Fees',
          style: Styles.styles14w600,
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payment Total',
              style: Styles.styles12NormalHalfBlack,
            ),
            Text(
              '\$$pricee/EG',
              style: Styles.styles14w600,
            )
          ],
        ),
        SizedBox(
          height: 110.h,
        ),
      ],
    );
  }
}

class SummaryItem extends StatelessWidget {
  final Color containerColor;
  final Color iconColor;
  final IconData icon;

  const SummaryItem(
      {super.key,
      required this.containerColor,
      required this.iconColor,
      required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0.r),
        color: containerColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.0.h),
        child: Icon(icon, color: iconColor, size: 22.sp),
      ),
    );
  }
}
