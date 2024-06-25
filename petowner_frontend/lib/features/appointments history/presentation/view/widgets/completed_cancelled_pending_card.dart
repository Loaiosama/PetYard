import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/home/presentation/view/widgets/pet_carer_card.dart';

class CompletedCancelledPendingTabCard extends StatelessWidget {
  const CompletedCancelledPendingTabCard({
    super.key,
    required this.appointmentStatus,
    required this.statusColor,
    required this.service,
    required this.providerName,
    required this.providerImage,
    this.boardingStartDate,
    this.boardingEndDate,
  });
  final String appointmentStatus;
  final Color statusColor;
  final String service;
  final String providerName;
  final String providerImage;
  final DateTime? boardingStartDate;
  final DateTime? boardingEndDate;
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
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(top: 14.0.h, left: 16.0.w, bottom: 14.0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointmentStatus,
                          style: Styles.styles12RegularOpacityBlack.copyWith(
                            color: statusColor,
                          ),
                        ),
                        heightSizedBox(4),
                        service == 'Boarding'
                            ? Text(
                                '${DateFormat('EEEE, d MMM').format(boardingStartDate ?? DateTime.now())} | ${DateFormat('EEEE, d MMM').format(boardingEndDate ?? DateTime.now())}',
                                style: Styles.styles12RegularOpacityBlack,
                              )
                            : Text(
                                'Monday, 24 Jun | 8:30',
                                style: Styles.styles12RegularOpacityBlack,
                              ),
                      ],
                    ),
                    IconButton(
                      onPressed: () async {},
                      icon: Tooltip(
                        message: 'More',
                        child: Icon(
                          Icons.more_vert_outlined,
                          color: Colors.black.withOpacity(0.5),
                          size: 22.0.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 16.0.w,
                  ),
                  child: const Divider(),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: 16.0.w,
                  ),
                  child: Row(
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
                          heightSizedBox(4),
                          Text(
                            'Pet $service',
                            style: Styles.styles12NormalHalfBlack,
                          ),
                          heightSizedBox(2),
                          const RatingRowWidget(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
