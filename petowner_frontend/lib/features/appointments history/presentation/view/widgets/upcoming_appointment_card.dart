import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';

class UpcomingAppointmentCard extends StatelessWidget {
  const UpcomingAppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0.h),
      child: Material(
        elevation: 1.0,
        type: MaterialType.card,
        // borderRadius: BorderRadius.circular(10.0.r),
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0.r),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.08),
          ),
        ),
        color: Colors.white,
        child: SizedBox(
          // height: 181,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
                top: 14.0.h, left: 16.0.w, right: 16.0.w, bottom: 14.0.h),
            child: Column(
              children: [
                Row(
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
                          'Olivia Austin',
                          style: Styles.styles16BoldBlack.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        heightSizedBox(4),
                        Text(
                          'Pet Sitting',
                          style: Styles.styles12NormalHalfBlack,
                        ),
                        heightSizedBox(2),
                        Text(
                          'Wed, 17 May | 08.30 AM',
                          style: Styles.styles12NormalHalfBlack,
                        ),
                      ],
                    ),
                    // widthSizedBox(10),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Tooltip(
                        message: 'Send a message to Olivia.',
                        child: Icon(
                          FluentIcons.chat_20_regular,
                          color: kPrimaryGreen,
                          size: 28.0.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                heightSizedBox(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PetYardTextButton(
                      onPressed: () {},
                      width: 140.w,
                      height: 50.h,
                      radius: 24.0.r,
                      color: Colors.transparent,
                      borderColor: kPrimaryGreen,
                      text: 'Cancel Appointment',
                      style: Styles.styles14w600.copyWith(
                        color: kPrimaryGreen,
                        fontSize: 11.sp,
                      ),
                    ),
                    PetYardTextButton(
                      onPressed: () {},
                      width: 140.w,
                      height: 50.h,
                      radius: 24.0.r,
                      text: 'Reschedule',
                      style: Styles.styles14w600.copyWith(
                        color: Colors.white,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
