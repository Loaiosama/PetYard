import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:petowner_frontend/core/utils/routing/routes.dart';
import 'package:petowner_frontend/core/utils/theming/colors.dart';
import 'package:petowner_frontend/core/utils/theming/styles.dart';
import 'package:petowner_frontend/core/widgets/petyard_text_button.dart';
import 'package:petowner_frontend/features/sitting/data/model/sitting_request%20.dart';
import 'package:petowner_frontend/features/sitting/presentation/view/widgets/summary_tab.dart';

class Requestscuccess extends StatelessWidget {
  final SittingRequest req;
  final String PetName;

  const Requestscuccess({
    Key? key,
    required this.req,
    required this.PetName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 70, right: 20, left: 20, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SvgPicture.asset(
                  'assets/svgs/circle-check-solid.svg',
                  width: 100.w,
                  height: 100.h,
                  colorFilter:
                      const ColorFilter.mode(kPrimaryGreen, BlendMode.srcIn),
                ),
              ),
              SizedBox(height: 22.h),
              Center(
                child: Text(
                  "Request Submitted",
                  style: Styles.styles20MediumBlack,
                ),
              ),
              SizedBox(height: 6.h),
              Center(
                child: Text(
                  "You will receive a notification when a provider accepts your request",
                  style: Styles.styles12NormalHalfBlack,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 40.h),
              Text(
                "Request Details",
                style: Styles.styles14w600,
              ),
              SizedBox(height: 20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SummaryItem(
                    containerColor: Color.fromRGBO(234, 242, 255, 1),
                    iconColor: Color.fromRGBO(36, 124, 255, 1),
                    icon: FontAwesomeIcons.solidCalendar,
                  ),
                  SizedBox(height: 10.w),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date',
                          style: Styles.styles12w600,
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          '- From ${DateFormat('EEE, d, MMM, yyyy, hh:mm:ss a').format(req.startTime ?? DateTime.now())}',
                          style: Styles.styles12NormalHalfBlack,
                        ),
                        Text(
                          '- To ${DateFormat('EEE, d, MMM, yyyy, hh:mm:ss a').format(req.endTime ?? DateTime.now())}',
                          style: Styles.styles12NormalHalfBlack,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Center(
                child: SizedBox(
                  width: 250.w,
                  child: Divider(
                    thickness: 1.5.sp,
                    color: kPrimaryGreen,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SummaryItem(
                    containerColor: Color.fromRGBO(233, 250, 239, 1),
                    iconColor: Color.fromRGBO(34, 197, 94, 1),
                    icon: Iconsax.clipboard_text4,
                  ),
                  SizedBox(width: 10.w),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Service",
                          style: Styles.styles12w600,
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          "Pet Sitting",
                          style: Styles.styles12NormalHalfBlack,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Center(
                child: SizedBox(
                  width: 250.w,
                  child: Divider(
                    thickness: 1.5.sp,
                    color: kPrimaryGreen,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SummaryItem(
                    containerColor: Color.fromRGBO(250, 233, 250, 1),
                    iconColor: Color.fromRGBO(197, 34, 170, 1),
                    icon: FontAwesomeIcons.paw,
                  ),
                  SizedBox(width: 10.w),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pet',
                          style: Styles.styles12w600,
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          PetName,
                          style: Styles.styles12NormalHalfBlack,
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Center(
                child: SizedBox(
                  width: 250.w,
                  child: Divider(
                    thickness: 1.5.sp,
                    color: kPrimaryGreen,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Cash',
                              style: Styles.styles12NormalHalfBlack,
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Text(
                              '${req.finalPrice}/EG',
                              style: Styles.styles12NormalHalfBlack,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Spacer(),
              PetYardTextButton(
                onPressed: () {
                  GoRouter.of(context).push(Routes.kHomeScreen, extra: 0);
                },
                text: 'Done',
                style: Styles.styles16BoldWhite,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
