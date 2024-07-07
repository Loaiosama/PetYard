import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:petowner_frontend/core/constants/constants.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';

class UpcomingAppointmentCard extends StatelessWidget {
  const UpcomingAppointmentCard({
    super.key,
    required this.providerName,
    required this.service,
    required this.providerImage,
    this.boardingStartDate,
    this.boardingEndDate,
    this.groomingStartTime,
    this.groomingEndTime,
    required this.slotPrice,
    required this.providerID,
    required this.ownerID,
    // required this.providerID,
  });
  final String providerName;
  final String service;
  final String providerImage;
  final DateTime? boardingStartDate;
  final DateTime? boardingEndDate;
  final DateTime? groomingStartTime;
  final DateTime? groomingEndTime;
  final num slotPrice;
  final int providerID;
  final int ownerID;
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
                        image: DecorationImage(
                          image: AssetImage(
                            '${Constants.profilePictures}/$providerImage',
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
                        heightSizedBox(4),
                        Text(
                          'Pet $service',
                          style: Styles.styles12NormalHalfBlack,
                        ),
                        heightSizedBox(2),
                        if (service == 'Boarding')
                          Text(
                            '-${DateFormat('EEEE, d MMM').format(boardingStartDate ?? DateTime.now())} \n-${DateFormat('EEEE, d MMM').format(boardingEndDate ?? DateTime.now())}',
                            style: Styles.styles12NormalHalfBlack,
                          ),
                        if (service == 'Grooming')
                          Text(
                            // '-From Wednesday, 08 May 2023',
                            DateFormat('EEEE, d MMM, yyyy')
                                .format(groomingStartTime!),
                            style: Styles.styles12NormalHalfBlack,
                          ),
                        Text(
                          // '-From Wednesday, 08 May 2023',
                          '${DateFormat('HH:mm').format(groomingStartTime!)} - '
                          '${DateFormat('HH:mm').format(groomingEndTime!)} ',
                          style: Styles.styles12NormalHalfBlack,
                        ),
                      ],
                    ),
                    // widthSizedBox(10),
                    const Spacer(),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            GoRouter.of(context)
                                .push(Routes.kChatScreen, extra: {
                              "senderId": ownerID,
                              "receiverId": providerID,
                              "role": 'petOwner',
                              // "senderId": chat.role == 'provider' ? chat.senderId : chat.receiverId,
                              // "receiverId":
                              //     chat.role == 'provider' ? chat.receiverId : chat.senderId,
                              // "role": chat.role
                            });
                          },
                          icon: Tooltip(
                            message: 'Send a message to $providerName.',
                            child: Icon(
                              FluentIcons.chat_20_regular,
                              color: kPrimaryGreen,
                              size: 28.0.sp,
                            ),
                          ),
                        ),
                        Text(
                          '$slotPrice/EGP',
                          style: Styles.styles12w600,
                        ),
                      ],
                    ),
                  ],
                ),
                heightSizedBox(20),
                PetYardTextButton(
                  onPressed: () {},
                  height: 50.h,
                  radius: 14.0.r,
                  text: 'Mark as done',
                  style: Styles.styles14w600.copyWith(
                    color: Colors.white,
                    fontSize: 11.sp,
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     // PetYardTextButton(
                //     //   onPressed: () {},
                //     //   width: 140.w,
                //     //   height: 50.h,
                //     //   radius: 24.0.r,
                //     //   color: Colors.transparent,
                //     //   borderColor: kPrimaryGreen,
                //     //   text: 'Cancel Appointment',
                //     //   style: Styles.styles14w600.copyWith(
                //     //     color: kPrimaryGreen,
                //     //     fontSize: 11.sp,
                //     //   ),
                //     // ),

                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
