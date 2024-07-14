import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:petowner_frontend/core/utils/helpers/spacing.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/features/provider%20profile/data/models/provider_info_model/data.dart';
import 'package:intl/intl.dart';
import 'package:petowner_frontend/features/provider%20profile/presentation/view/widgets/provider_profile_card.dart';

class GroomingSummaryTab extends StatelessWidget {
  const GroomingSummaryTab({
    super.key,
    required this.providerName,
    required this.date,
    required this.fees,
    required this.selectedPetName,
    required this.service,
    required this.types,
    required this.startTime,
    this.endTime,
    required this.providerImage,
    required this.rating,
    this.count,
  });
  final String providerName;
  final DateTime? date;
  final DateTime startTime;
  final DateTime? endTime;
  final List types;
  final double fees;
  final String selectedPetName;
  final List<Service> service;
  final String providerImage;
  final num rating;
  final dynamic count;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking Information',
          style: Styles.styles14w600,
        ),
        heightSizedBox(10),
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
                  // '-From Wednesday, 08 May 2023',
                  DateFormat('EEEE, d MMM, yyyy').format(date!),
                  style: Styles.styles12NormalHalfBlack,
                ),
                Text(
                  // '-From Wednesday, 08 May 2023',
                  '${DateFormat('HH:mm').format(startTime)} - '
                  '${DateFormat('HH:mm').format(endTime!)} ',
                  style: Styles.styles12NormalHalfBlack,
                ),
                // Text(
                //   '-To ${DateFormat('EEEE, d MMM, yyyy').format(endDate!)}',
                //   style: Styles.styles12NormalHalfBlack,
                // ),
              ],
            ),
          ],
        ),
        heightSizedBox(12),
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
                  'Pet Grooming',
                  style: Styles.styles12NormalHalfBlack,
                ),
                Row(
                  children: List.generate(
                      types.length,
                      (index) => Text(
                            types.length == 1
                                ? '${types[index]} '
                                : '${types[index]}, ',
                            style: Styles.styles12NormalHalfBlack,
                          )),
                )
              ],
            ),
          ],
        ),
        heightSizedBox(12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SummaryIconContainer(
              containerColor: Color.fromRGBO(250, 233, 250, 1),
              iconColor: Color.fromRGBO(197, 34, 170, 1),
              icon: FontAwesomeIcons.paw,
            ),
            widthSizedBox(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pet',
                  style: Styles.styles12w600,
                ),
                heightSizedBox(2),
                Text(
                  selectedPetName,
                  style: Styles.styles12NormalHalfBlack,
                ),
              ],
            ),
          ],
        ),
        heightSizedBox(14),
        Text(
          'Pet Carer Information',
          style: Styles.styles14w600,
        ),
        heightSizedBox(10),
        ProviderProfileCard(
          services: service,
          providerName: providerName,
          count: count,
          rating: rating,
          image: providerImage,
        ),
        heightSizedBox(14),
        Text(
          'Payment Information',
          style: Styles.styles14w600,
        ),
        heightSizedBox(10),
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
        heightSizedBox(14),
        Text(
          'Total Fees',
          style: Styles.styles14w600,
        ),
        heightSizedBox(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Payment Total',
              style: Styles.styles12NormalHalfBlack,
            ),
            Text(
              '\$$fees/EG',
              style: Styles.styles14w600,
            )
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
