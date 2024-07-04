import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';

class LocationTabColumn extends StatelessWidget {
  const LocationTabColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heightSizedBox(12),
        Row(
          children: [
            Icon(
              FontAwesomeIcons.locationDot,
              color: const Color.fromRGBO(255, 76, 94, 1),
              size: 16.sp,
            ),
            widthSizedBox(8),
            Text(
              'Cairo, Egypt',
              style: Styles.styles12NormalHalfBlack,
            ),
          ],
        ),
        heightSizedBox(18),
        Text(
          'Location Map',
          style: Styles.styles14w600,
        ),
        heightSizedBox(10),
        Container(
          height: 360.h,
          width: double.infinity,
          color: Colors.red,
        ),
      ],
    );
  }
}
