import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class AboutTabColumn extends StatelessWidget {
  const AboutTabColumn(
      {super.key,
      required this.serviceName,
      required this.bio,
      required this.email,
      required this.phoneNumber,
      required this.userName});
  final String userName;
  final String serviceName;
  final String bio;
  final String email;
  // final String age;
  final String phoneNumber;
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
            bio,
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
            'Other Services Provided By $userName',
            style: Styles.styles14w600,
          ),
          heightSizedBox(8),
          Text(
            'services ya back',
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
                phoneNumber,
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
                email,
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
                '26 years old."age ya back"',
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
                '20 Completed bookings hmm',
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
