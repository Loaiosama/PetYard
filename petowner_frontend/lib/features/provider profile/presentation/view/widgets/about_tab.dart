import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class AboutTabColumn extends StatelessWidget {
  const AboutTabColumn({super.key, required this.serviceName});
  final String serviceName;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightSizedBox(12),
          Text(
            'About me',
            style: Styles.styles14w600,
          ),
          heightSizedBox(8),
          Text(
            'Dr. Jenny Watson is the top most Immunologists specialist in Christ Hospital at London. She achived several awards for her wonderful contribution in medical field. She is available for private consultation.',
            style: Styles.styles12NormalHalfBlack,
          ),
          heightSizedBox(18),
          Text(
            'Service',
            style: Styles.styles14w600,
          ),
          heightSizedBox(8),
          Text(
            serviceName,
            style: Styles.styles12NormalHalfBlack,
          ),
          heightSizedBox(18),
          Text(
            'Working Time',
            style: Styles.styles14w600,
          ),
          heightSizedBox(8),
          Text(
            'Monday - Friday, 08.00 AM - 20.00 PM',
            style: Styles.styles12NormalHalfBlack,
          ),
          heightSizedBox(18),
          Text(
            'More Info',
            style: Styles.styles14w600,
          ),
          heightSizedBox(8),
          Row(
            children: [
              Icon(
                Icons.phone_android_outlined,
                color: Colors.black.withOpacity(0.4),
                size: 18.sp,
              ),
              widthSizedBox(8),
              Text(
                '+201016768605',
                style: Styles.styles12NormalHalfBlack,
              ),
            ],
          ),
          heightSizedBox(5),
          Row(
            children: [
              Icon(
                Icons.email_outlined,
                color: Colors.black.withOpacity(0.4),
                size: 18.sp,
              ),
              widthSizedBox(8),
              Text(
                'oliviaaustin@gmail.com',
                style: Styles.styles12NormalHalfBlack,
              ),
            ],
          ),
          heightSizedBox(5),
          Row(
            children: [
              Icon(
                Icons.date_range_outlined,
                color: Colors.black.withOpacity(0.4),
                size: 18.sp,
              ),
              widthSizedBox(8),
              Text(
                '26 years old.',
                style: Styles.styles12NormalHalfBlack,
              ),
            ],
          ),
          heightSizedBox(18),
          Text(
            'Bookings',
            style: Styles.styles14w600,
          ),
          heightSizedBox(8),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.purple,
                radius: 6.r,
              ),
              widthSizedBox(8),
              Text(
                '20 Completed bookings',
                style: Styles.styles12NormalHalfBlack,
              ),
            ],
          ),
          heightSizedBox(5),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: kBlue,
                radius: 6.r,
              ),
              widthSizedBox(8),
              Text(
                '10 Repeated Customers',
                style: Styles.styles12NormalHalfBlack,
              ),
            ],
          ),
          heightSizedBox(5),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.greenAccent,
                radius: 6.r,
              ),
              widthSizedBox(8),
              Text(
                '6 Repeated bookings',
                style: Styles.styles12NormalHalfBlack,
              ),
            ],
          ),
          /* 
          Should we add more info here and database like 
          Distance willing to travel,
          Accepted Pet Types,
          Accepted Pet size,
          */
        ],
      ),
    );
  }
}
