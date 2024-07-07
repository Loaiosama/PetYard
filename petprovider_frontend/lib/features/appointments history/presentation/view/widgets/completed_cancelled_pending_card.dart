import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:petprovider_frontend/core/constants/constants.dart';
import 'package:petprovider_frontend/core/utils/helpers/spacing.dart';
import 'package:petprovider_frontend/core/utils/theming/styles.dart';

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
    required this.slotPrice,
    required this.status,
    this.providerId,
    this.groomingStartTime,
    this.groomingEndTime,
    required this.rate,
    required this.rateCount,
    required this.petName,
    required this.petImage,
  });
  final int? providerId;
  final String appointmentStatus;
  final Color statusColor;
  final String service;
  final String providerName;
  final String providerImage;
  final DateTime? boardingStartDate;
  final DateTime? boardingEndDate;
  final DateTime? groomingStartTime;
  final DateTime? groomingEndTime;
  final num slotPrice;
  final String status;
  final num rate;
  final dynamic rateCount;
  final String petName;
  final String petImage;
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
                          style: Styles.styles12NormalHalfBlack.copyWith(
                            color: statusColor,
                          ),
                        ),
                        heightSizedBox(4),
                        if (service == 'Boarding')
                          Text(
                            '${DateFormat('EEEE, d MMM').format(boardingStartDate ?? DateTime.now())} | ${DateFormat('EEEE, d MMM').format(boardingEndDate ?? DateTime.now())}',
                            style: Styles.styles12NormalHalfBlack,
                          ),
                        if (service == 'Grooming')
                          Text(
                            '',
                            style: Styles.styles12NormalHalfBlack,
                          ),
                      ],
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 80.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                // 'assets/images/1.png',
                                '${Constants.profilePictrues}/$petImage'),
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
                            petName,
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
                        ],
                      ),
                      const Spacer(),
                      Text(
                        '$slotPrice/EGP',
                        style: Styles.styles12w600,
                      )
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
